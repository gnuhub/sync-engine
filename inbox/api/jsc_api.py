import sys
import urllib
import requests
import simplejson
import json
from bson import json_util
from datetime import datetime, timedelta
from socket import gaierror
from flask import request, g, Blueprint, make_response
from flask import jsonify as flask_jsonify
from flask.ext.restful import reqparse
from inbox.api.validation import valid_public_id, bounded_str, strict_parse_args, ValidatableArgument
from inbox.basicauth import NotSupportedError, ValidationError
from inbox.models.session import session_scope, global_session_scope
from inbox.api.err import APIException, InputError, log_exception
from inbox.auth.gmail import GmailAuthHandler
from inbox.models import Account, Namespace
from inbox.auth.base import handler_from_provider
from inbox.util.url import provider_from_address
from inbox.providers import providers
from inbox.mailsync.service import shared_sync_event_queue_for_zone
from inbox.config import config

app = Blueprint(
    'jobscore_custom_api',
    __name__,
    url_prefix='/c')

app.log_exception = log_exception

DEFAULT_IMAP_PORT = 143
DEFAULT_IMAP_SSL_PORT = 993
DEFAULT_SMTP_PORT = 25
DEFAULT_SMTP_SSL_PORT = 465

def unprocessable_entity_response(message):
    response = simplejson.dumps({ 'message': message, 'type': 'custom_api_error' })
    return make_response((response, 422, { 'Content-Type': 'application/json' }))

def find_account_shard(email_address):
    with global_session_scope() as db_session:
        account = db_session.query(Account).filter_by(email_address=email_address).first()
        if account is not None:
            return account.id

    return None

@app.before_request
def start():
    request.environ['log_context'] = {
        'endpoint': request.endpoint,
    }
    # g.encoder = APIEncoder(g.namespace.public_id, is_n1=is_n1)
    g.parser = reqparse.RequestParser(argument_class=ValidatableArgument)


@app.errorhandler(APIException)
def handle_input_error(error):
    # these "errors" are normal, so we don't need to save a traceback
    request.environ['log_context']['error'] = error.__class__.__name__
    request.environ['log_context']['error_message'] = error.message
    response = flask_jsonify(message=error.message,
                             type='invalid_request_error')
    response.status_code = error.status_code
    return response


@app.errorhandler(Exception)
def handle_generic_error(error):
    log_exception(sys.exc_info())
    response = flask_jsonify(message=error.message,
                             type='api_error')
    response.status_code = 500
    return response

@app.route('/suspend_sync', methods=['POST'])
def suspend_sync():
    g.parser.add_argument('account_id', required=True, type=valid_public_id, location='form')
    args = strict_parse_args(g.parser, request.args)

    namespace_public_id = args['account_id']
    with global_session_scope() as db_session:
        namespace = db_session.query(Namespace) \
          .filter(Namespace.public_id == namespace_public_id).one()
        namespace_id = namespace.id

    with session_scope(namespace_id) as db_session:
        namespace = db_session.query(Namespace) \
            .filter(Namespace.public_id == namespace_public_id).one()
        account = namespace.account

        account.sync_should_run = False
        account._sync_status['sync_disabled_reason'] = 'suspend_account API endpoint called'
        account._sync_status['sync_disabled_on'] = datetime.utcnow()
        account._sync_status['sync_disabled_by'] = 'api'
        account._sync_status['sync_status'] = 0

        db_session.commit()

        shared_queue = shared_sync_event_queue_for_zone(config.get('ZONE'))
        shared_queue.send_event({ 'event': 'sync_suspended', 'id': account.id })

        resp = json.dumps(account._sync_status, default=json_util.default)
        return make_response((resp, 200, {'Content-Type': 'application/json'}))

@app.route('/enable_sync', methods=['POST'])
def enable_sync():
    g.parser.add_argument('account_id', required=True, type=valid_public_id, location='form')
    args = strict_parse_args(g.parser, request.args)

    account_id = None

    namespace_public_id = args['account_id']
    with global_session_scope() as db_session:
        namespace = db_session.query(Namespace) \
            .filter(Namespace.public_id == namespace_public_id).one()
        account_id = namespace.account.id

    with session_scope(account_id) as db_session:
        try:
            account = db_session.query(Account).with_for_update() \
                .filter(Account.id == account_id).one()

            lease_period = timedelta(seconds=5)
            time_ended = account.sync_status.get('sync_end_time')
            time_now = datetime.utcnow()

            if account.sync_host is None and account.sync_state != 'running' \
                and (time_ended is None or time_now > time_ended + lease_period):
                account.sync_should_run = True

                if account.provider == 'gmail':
                    creds = account.auth_credentials
                    for c in creds:
                        c.is_valid = True

                db_session.commit()

            resp = json.dumps(account.sync_status, default=json_util.default)
            return make_response((resp, 200, {'Content-Type': 'application/json'}))
        except NotSupportedError as e:
            resp = simplejson.dumps({'message': str(e), 'type': 'custom_api_error'})
            return make_response((resp, 400, {'Content-Type': 'application/json'}))


@app.route('/auth_callback')
def auth_callback():
    g.parser.add_argument('authorization_code', type=bounded_str, location='args', required=True)
    g.parser.add_argument('email', required=True, type=bounded_str, location='args')
    args = strict_parse_args(g.parser, request.args)

    target = find_account_shard(args['email'])
    if target is None:
        target = config.get('NEW_ACCOUNTS_DEFAULT_SHARD', 0) << 48

    with session_scope(target) as db_session:
        account = db_session.query(Account).filter_by(email_address=args['email']).first()

        updating_account = False
        if account is not None:
            updating_account = True

        auth_handler = handler_from_provider('gmail')

        request_args = {
            'client_id': GmailAuthHandler.OAUTH_CLIENT_ID,
            'client_secret': GmailAuthHandler.OAUTH_CLIENT_SECRET,
            'redirect_uri': GmailAuthHandler.OAUTH_REDIRECT_URI,
            'code': args['authorization_code'],
            'grant_type': 'authorization_code'
        }

        headers = {'Content-type': 'application/x-www-form-urlencoded',
                   'Accept': 'text/plain'}

        data = urllib.urlencode(request_args)
        resp_dict = requests.post(auth_handler.OAUTH_ACCESS_TOKEN_URL, data=data, headers=headers).json()

        if u'error' in resp_dict:
            raise APIException('Internal error: ' + str(resp_dict['error']))

        access_token = resp_dict['access_token']
        validation_dict = auth_handler.validate_token(access_token)
        userinfo_dict = auth_handler._get_user_info(access_token)

        if userinfo_dict['email'].lower() != args['email'].lower():
            raise InputError('Email mismatch')

        resp_dict.update(validation_dict)
        resp_dict.update(userinfo_dict)
        resp_dict['contacts'] = True
        resp_dict['events'] = True

        auth_info = {'provider': 'gmail'}
        auth_info.update(resp_dict)

        if updating_account:
            account.auth_handler.update_account(account, auth_info)
        else:
            account = auth_handler.create_account(args['email'], auth_info)

        try:
            if auth_handler.verify_account(account):
                db_session.add(account)
                db_session.commit()
        except NotSupportedError:
            raise APIException('Internal error: ' + str(resp_dict['error']))

        resp = simplejson.dumps({
            'account_id': account.public_id,
            'namespace_id': account.namespace.public_id
        })

        return make_response((resp, 201, {'Content-Type': 'application/json'}))

@app.route('/create_account', methods=['POST'])
def create_account():
    g.parser.add_argument('email', required=True, type=bounded_str, location='form')
    g.parser.add_argument('smtp_host', required=True, type=bounded_str, location='form')
    g.parser.add_argument('smtp_port', type=int, location='form')
    g.parser.add_argument('smtp_username', required=True, type=bounded_str, location='form')
    g.parser.add_argument('smtp_password', required=True, type=bounded_str, location='form')
    g.parser.add_argument('imap_host', required=True, type=bounded_str, location='form')
    g.parser.add_argument('imap_port', type=int, location='form')
    g.parser.add_argument('imap_username', required=True, type=bounded_str, location='form')
    g.parser.add_argument('imap_password', required=True, type=bounded_str, location='form')
    g.parser.add_argument('ssl_required', required=True, type=bool, location='form')
    args = strict_parse_args(g.parser, request.args)

    target = find_account_shard(args['email'])
    if target is None:
        target = config.get('NEW_ACCOUNTS_DEFAULT_SHARD', 0) << 48

    with session_scope(target) as db_session:
        account = db_session.query(Account).filter_by(email_address=args['email']).first()

        provider_auth_info = dict(provider='custom',
                                  email=args['email'],
                                  imap_server_host=args['imap_host'],
                                  imap_server_port=(args.get('imap_port') or DEFAULT_IMAP_SSL_PORT),
                                  imap_username=args['imap_username'],
                                  imap_password=args['imap_password'],
                                  smtp_server_host=args['smtp_host'],
                                  smtp_server_port=(args.get('smtp_port') or DEFAULT_SMTP_SSL_PORT),
                                  smtp_username=args['smtp_username'],
                                  smtp_password=args['smtp_password'],
                                  ssl_required=args['ssl_required'])

        auth_handler = handler_from_provider(provider_auth_info['provider'])

        if account is None:
            account = auth_handler.create_account(args['email'], provider_auth_info)
        else:
            account = account.auth_handler.update_account(account, provider_auth_info)

        try:
            resp = None

            if auth_handler.verify_account(account):
                db_session.add(account)
                db_session.commit()
                resp = simplejson.dumps({
                    'account_id': account.public_id,
                    'namespace_id': account.namespace.public_id
                })
                return make_response((resp, 201, { 'Content-Type': 'application/json' }))
            else:
                resp = simplejson.dumps({ 'message': 'Account verification failed', 'type': 'api_error' })
                return make_response((resp, 422, { 'Content-Type': 'application/json' }))
        except ValidationError as e:
            return unprocessable_entity_response(e.message.message)
        except gaierror as error:
            if error[1] == 'Name or service not known':
                return unprocessable_entity_response(error[1])
            else:
                raise error
        except NotSupportedError as e:
            resp = simplejson.dumps({ 'message': str(e), 'type': 'custom_api_error' })
            return make_response((resp, 400, { 'Content-Type': 'application/json' }))


@app.route('/provider_from_email', methods=['get'])
def provider_from_email():
    g.parser.add_argument('email', required=True, type=bounded_str, location='args')
    args = strict_parse_args(g.parser, request.args)

    try:
        provider_name = provider_from_address(args['email'])
        provider_info = providers[provider_name] if provider_name != 'unknown' else 'unknown'

        resp = simplejson.dumps({
            'provider_name': provider_name,
            'provider_info': provider_info
        })

        return make_response((resp, 200, { 'Content-Type': 'application/json' }))
    except NotSupportedError as e:
        resp = simplejson.dumps({ 'message': str(e), 'type': 'custom_api_error' })
        return make_response((resp, 400, { 'Content-Type': 'application/json' }))

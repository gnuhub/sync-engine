#!/usr/bin/env bash
set -x
echo "run./bin/inbox-auth"

export PATH=${HOME}/anaconda/bin/:$PATH

CMD_PATH=$(cd `dirname $0`; pwd)
source activate py27

export PYTHONPATH=$CMD_PATH
export NYLAS_ENV=dev

./bin/inbox-auth $1
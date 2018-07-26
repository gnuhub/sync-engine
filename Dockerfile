FROM ubuntu:14.04


ADD . /src
RUN /src/docker.setup.sh
RUN /src/setup.sh
ADD api.sv.conf /etc/supervisor/conf.d/
ADD docker.start.engine.sh /etc/supervisor/conf.d/


CMD supervisord -c /etc/supervisor.conf
FROM ubuntu:16.04




ADD . /src
RUN /src/setup.indocker.sh
RUN /src/docker.setup.sh

ADD supervisor.conf /etc/supervisor.conf
ADD mysql.sv.conf /etc/supervisor/conf.d/
ADD init.sv.conf /etc/supervisor/conf.d/
ADD api.sv.conf /etc/supervisor/conf.d/
ADD engine.sv.conf /etc/supervisor/conf.d/



CMD supervisord -c /etc/supervisor.conf
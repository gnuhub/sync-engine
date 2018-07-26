FROM ubuntu:14.04.1

services:
  - docker:dind

ADD . /src
ADD api.sv.conf /etc/supervisor/conf.d/
ADD docker.start.engine.sh /etc/supervisor/conf.d/
RUN /src/docker.setup.sh
RUN /src/setup.sh

CMD supervisord -c /etc/supervisor.conf
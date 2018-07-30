FROM gnuhub/sync-engine:latest

ADD . /src

RUN /src/docker.sh

ADD supervisor.conf /etc/supervisor.conf
ADD api.sv.conf /etc/supervisor/conf.d/
ADD engine.sv.conf /etc/supervisor/conf.d/

CMD /src/supervisord.start.sh
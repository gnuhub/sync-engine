#FROM daocloud.io/gnuhub3/python_docker:latest
FROM sync-engine:aacc004d



ADD . /src

RUN /src/docker.sh

ADD supervisor.conf /etc/supervisor.conf
ADD api.sv.conf /etc/supervisor/conf.d/
ADD engine.sv.conf /etc/supervisor/conf.d/



CMD /src/supervisord.start.sh
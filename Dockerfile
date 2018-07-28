FROM daocloud.io/gnuhub3/python_docker:latest




ADD . /src

RUN /src/docker.sh

ADD supervisor.conf /etc/supervisor.conf
ADD init.sv.conf /etc/supervisor/conf.d/
ADD api.sv.conf /etc/supervisor/conf.d/
ADD engine.sv.conf /etc/supervisor/conf.d/



CMD supervisord -c /etc/supervisor.conf
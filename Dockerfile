FROM gnuhub/sync-engine:87ab5bee

RUN useradd --create-home --no-log-init --shell /bin/bash syncengine3
RUN adduser syncengine3 sudo
RUN echo 'syncengine3:syncengine3' | chpasswd
USER syncengine3
WORKDIR /home/syncengine3

ADD . /home/syncengine3/

RUN /home/syncengine3/docker.sh

ADD supervisor.conf /etc/supervisor.conf
ADD api.sv.conf /etc/supervisor/conf.d/
ADD engine.sv.conf /etc/supervisor/conf.d/

CMD /home/syncengine3/supervisord.start.sh
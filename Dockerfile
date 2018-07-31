FROM gnuhub/sync-engine:latest



ADD docker.root.sh /src2/docker.root.sh
RUN /src2/docker.root.sh

USER syncengine3


WORKDIR /home/syncengine3

ADD . /home/syncengine3/
USER root
RUN /home/syncengine3/docker.user.sh
USER syncengine3



CMD /home/syncengine3/supervisord.start.sh
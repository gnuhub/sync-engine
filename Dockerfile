FROM gnuhub/sync-engine:87ab5bee



ADD docker.sh /src2/docker.sh
RUN /src2/docker.root.sh

USER syncengine3


WORKDIR /home/syncengine3

ADD . /home/syncengine3/
RUN /home/syncengine3/docker.user.sh




CMD /home/syncengine3/supervisord.start.sh
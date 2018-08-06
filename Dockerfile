FROM gnuhub/sync-engine:latest


USER root
ADD docker.root.sh /src2/docker.root.sh
RUN /src2/docker.root.sh

USER syncengine4

WORKDIR /home/syncengine4
ADD . /home/syncengine4/

USER root
RUN /home/syncengine4/docker.user.sh
USER syncengine4



CMD /home/syncengine4/supervisord.start.sh
FROM continuumio/miniconda3:latest
#FROM gnuhub/sync-engine:latest


USER root

ADD docker.root.sh /src2/docker.root.sh
RUN /src2/docker.root.sh

WORKDIR /home/syncengine4
RUN rm -rf *

USER syncengine4

WORKDIR /home/syncengine4
RUN rm -rf *
ADD . /home/syncengine4/

USER root
RUN /home/syncengine4/docker.user.sh
USER syncengine4



CMD /home/syncengine4/supervisord.start.sh
#!/usr/bin/env bash
#apt-get install -y 
#docker run  -v ${PWD}:/data gnuhub/sync-engine:latest apt-cache search libxslt

docker run  -v ${PWD}:/data gnuhub/sync-engine:latest bash /home/syncengine3/docker.start.engine.sh
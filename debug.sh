#!/usr/bin/env bash
docker run  -v ${PWD}:/data gnuhub/sync-engine:latest /home/syncengine3/supervisord.start.sh
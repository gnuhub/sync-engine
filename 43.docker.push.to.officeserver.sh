#!/usr/bin/env bash
VERSION=$(git rev-parse --short HEAD)
reg_host=192.168.31.10:5000

docker tag sync-engine:$VERSION ${reg_host}/sync-engine:$VERSION
docker tag sync-engine:$VERSION ${reg_host}/sync-engine:latest
docker push ${reg_host}/sync-engine:$VERSION
docker push ${reg_host}/sync-engine:latest
#!/usr/bin/env bash
VERSION=$(git rev-parse --short HEAD)

docker tag sync-engine:$VERSION gnuhub/sync-engine:$VERSION
docker push gnuhub/sync-engine:$VERSION
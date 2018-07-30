#!/usr/bin/env bash

docker pull  registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest
docker tag registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest gnuhub/sync-engine:latest
docker push gnuhub/sync-engine:latest
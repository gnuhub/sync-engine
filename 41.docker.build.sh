#!/usr/bin/env bash

set -x
## 获取当前源码版本
VERSION=$(git rev-parse --short HEAD)

## 构建镜像
docker build -t sync-engine:$VERSION .
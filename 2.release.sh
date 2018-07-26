set -x
## 获取当前源码版本
VERSION=$(git rev-parse --short HEAD)
docker build -t registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest .
docker push registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest
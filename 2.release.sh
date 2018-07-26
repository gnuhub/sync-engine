set -x
## 获取当前源码版本
docker build -t registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest .
docker push registry.gitlab.com/bxqd_gitlabci_201807/sync-engine:latest
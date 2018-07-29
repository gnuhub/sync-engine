#usr/bin/env bash
source activate py27
## 记录当前路径
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH
# after mysql started
sleep 2
su - syncengine -c "PYTHONPATH=`pwd` NYLAS_ENV=dev bin/create-db"
su - syncengine -c "PYTHONPATH=`pwd` NYLAS_ENV=dev ./bin/inbox-start"
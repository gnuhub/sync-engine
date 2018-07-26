#usr/bin/env bash

## 记录当前路径
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH
# after mysql started
sleep 10
PYTHONPATH=`pwd` NYLAS_ENV=dev bin/create-db
PYTHONPATH=`pwd` NYLAS_ENV=dev bin/create-test-db
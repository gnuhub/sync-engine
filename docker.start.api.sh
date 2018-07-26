#usr/bin/env bash

## 记录当前路径
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH
sleep 20
PYTHONPATH=`pwd` NYLAS_ENV=dev bin/inbox-api -p 9999
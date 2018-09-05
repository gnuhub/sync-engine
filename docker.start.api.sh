#usr/bin/env bash
set -x
source activate py27
## 记录当前路径
# CMD_PATH=$(cd `dirname $0`; pwd)
cd /home/syncengine3/
sleep 40
PYTHONPATH=`pwd` NYLAS_ENV=dev bin/inbox-api -p 9999
#!/usr/bin/env bash
set -x
echo "run bin/ctreate-db  bin/ctreate-test-db"

export PATH=${HOME}/anaconda/bin/:$PATH

CMD_PATH=$(cd `dirname $0`; pwd)
source activate py27

export PYTHONPATH=$CMD_PATH
export NYLAS_ENV=dev

./bin/create-db
./bin/create-test-db

# error: + ./bin/create-test-db
# ERROR 1805 (HY000) at line 1: Column count of mysql.user is wrong. Expected 45, found 46. The table is probably corrupted

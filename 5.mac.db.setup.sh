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

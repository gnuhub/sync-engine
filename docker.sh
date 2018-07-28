#!/usr/bin/env bash
set -x
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH

conda create -y -vvv -n py27 python=2.7

echo "---------check anaconda installation--------------"
which python
conda --version
conda info
conda env list

echo "---------source activate py27---------------------"
source activate py27
which python
python --version

echo "setup py27 using Anaconda Done"

echo 'UTC' | tee /etc/timezone

mkdir -p /var/lib/inboxapp/parts

pip install -r requirements.txt
pip install -e .

export PYTHONPATH=$CMD_PATH
export NYLAS_ENV=dev

./bin/create-db
./bin/create-test-db
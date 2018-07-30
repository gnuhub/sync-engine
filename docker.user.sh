#!/usr/bin/env bash
set -x
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH

echo "---------source activate py27---------------------"
source activate py27


pip install -r requirements.txt
pip install -e .


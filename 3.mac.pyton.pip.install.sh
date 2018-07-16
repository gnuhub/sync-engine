#!/usr/bin/env bash
export PATH=/usr/local/bin/:${HOME}/anaconda/bin/:$PATH
source activate py27
pip uninstall -y python-dateutil
pip uninstall -y flanker
pip uninstall -y imapclient

pip install -r requirements.txt
pip install -e .

#!/usr/bin/env bash
# https://github.com/gnuhub/sync-engine/issues/2
brew install lua
# https://github.com/gnuhub/sync-engine/issues/3
brew install mysql-connector-c

source activate py27
conda env export -n py27 > py27.yaml
pip install -r requirements.txt
conda env export -n py27 > py27.yaml

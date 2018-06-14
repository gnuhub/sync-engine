#!/usr/bin/env bash
# https://github.com/gnuhub/sync-engine/issues/2
brew install lua
# https://github.com/gnuhub/sync-engine/issues/3
brew install mysql-connector-c
# https://github.com/gnuhub/sync-engine/issues/8
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# https://github.com/gnuhub/sync-engine/issues/9#issuecomment-397225469
ln -s /Applications/XAMPP/xamppfiles/var/mysql/mysql.sock /tmp/mysql.sock

source activate py27
pip uninstall -y python-dateutil
pip uninstall -y flanker

conda env export -n py27 > py27.yaml
pip install -r requirements.txt
pip install -e .
conda env export -n py27 > py27.yaml

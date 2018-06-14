#!/usr/bin/env bash

# https://github.com/gnuhub/sync-engine/issues/2
brew install lua

# https://github.com/gnuhub/sync-engine/issues/3
brew install mysql-connector-c

# https://github.com/gnuhub/sync-engine/issues/8
# some more actions
# https://github.com/gnuhub/sync-engine/issues/8#issuecomment-397231081
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# https://github.com/gnuhub/sync-engine/issues/9#issuecomment-397225469
if [ -d /Applications/XAMPP ];then
    ln -sv /Applications/XAMPP/xamppfiles/var/mysql/mysql.sock /tmp/mysql.sock
fi

# https://github.com/gnuhub/sync-engine/issues/12
sudo mkdir -p /var/lib/inboxapp/parts
sudo chmod -R 777 /var/lib/inboxapp

source activate py276
pip uninstall -y python-dateutil
pip uninstall -y flanker
pip uninstall -y imapclient

conda env export -n py276 > py276.yaml
pip install -r requirements.txt
pip install -e .
conda env export -n py276 > py276.yaml

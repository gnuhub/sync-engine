#!/usr/bin/env bash
echo "install dependency and fix the problems on mac"
brew install redis
brew services start redis

# https://github.com/gnuhub/sync-engine/issues/2
brew install lua

# https://github.com/gnuhub/sync-engine/issues/3
brew install mysql-connector-c

# https://github.com/gnuhub/sync-engine/issues/12
sudo mkdir -p /var/lib/inboxapp/parts
sudo chmod -R 777 /var/lib/inboxapp

# https://github.com/gnuhub/sync-engine/issues/8
# some more actions
# https://github.com/gnuhub/sync-engine/issues/8#issuecomment-397231081

echo "System time must set to UTC"
echo "to fix the mac os auto change the timezone"
echo "please uncheck the two boxes follows the setps in"
echo  "https://github.com/gnuhub/sync-engine/issues/8#issuecomment-397231081"

sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime
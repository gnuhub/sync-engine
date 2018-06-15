#!/usr/bin/env bash

# https://github.com/gnuhub/sync-engine/issues/9#issuecomment-397225469
if [ -d /Applications/XAMPP ];then
    ln -sfv /Applications/XAMPP/xamppfiles/var/mysql/mysql.sock /tmp/mysql.sock
fi

echo "if you don't use XAMPP you should make sure the mysql server socket file is in or linked to /tmp/mysql.sock "
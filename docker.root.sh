#!/usr/bin/env bash
set -x
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH

# if [ ! -f oh-my-tuna.py ];then
# wget wget https://tuna.moe/oh-my-tuna/oh-my-tuna.py
# fi
# python oh-my-tuna.py

useradd --create-home --no-log-init --shell /bin/bash syncengine4
adduser syncengine4 sudo
echo 'syncengine4:syncengine4' | chpasswd
echo 'root:root' | chpasswd

apt-get clean -y
apt-get update -y
apt-get install -f -y
apt-get install lsb-core -y
apt-get install gnupg -y
if [ ! -f mysql-apt-config_0.8.9-1_all.deb ];then
wget https://repo.mysql.com/mysql-apt-config_0.8.9-1_all.deb
fi
dpkg -i mysql-apt-config_0.8.9-1_all.deb
apt-get update -y

apt-cache search mysql
apt-cache search lua

apt-get install -y build-essential
apt-get install -y m4
apt-get install -y flex
apt-get install -y bison
apt-get install -y gawk
apt-get install -y texinfo
apt-get install -y autoconf
apt-get install -y libtool
apt-get install -y pkg-config
apt-get install -y openssl 
apt-get install -y curl 
apt-get install -y git 
apt-get install -y zlib1g 
apt-get install -y autoconf 
apt-get install -y automake 
apt-get install -y libtool 
apt-get install -y imagemagick 
apt-get install -y make
apt-get install -y tree
apt-get install -y lua5.2 liblua5.2-dev
apt-get install -y libxslt1.1 
apt-get install -y libxslt1-dev

apt-get install default-libmysqlclient-dev -y
apt-get install mysql-client -y





conda create -y -n py27 python=2.7

echo "---------check anaconda installation--------------"
which python
conda --version
conda info
conda env list

echo "---------source activate py27---------------------"
source activate py27
which python
python --version

pip install supervisor
mkdir -p /var/log/supervisor
# create directory for child images to store configuration in
mkdir -p /etc/supervisor/conf.d

echo "setup py27 using Anaconda Done"

echo 'UTC' | tee /etc/timezone

mkdir -p /var/lib/inboxapp/parts
# Y18-93 sync-engine Permission denied: '/var/lib/inboxapp/parts/
chmod -R 777 /var/lib/inboxapp/parts



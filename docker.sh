#!/usr/bin/env bash
set -x
CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH


apt-get clean -y
apt-get update -y
apt-get install -f -y
apt-get install lsb-core -y
wget https://repo.mysql.com/mysql-apt-config_0.8.9-1_all.deb

dpkg -i mysql-apt-config_0.8.9-1_all.deb
apt-get update -y
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

pip install -r requirements.txt
pip install -e .


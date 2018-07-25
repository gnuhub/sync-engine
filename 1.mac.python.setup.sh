#!/usr/bin/env bash
set -x
echo "setup py27 using Anaconda begin ..."

brew install wget

cd ~

file=Anaconda3-5.2.0-MacOSX-x86_64.sh

## the tmp is a link on my os
if [ ! -f ~/tmp/$file ];then
    mkdir tmp
fi

cd tmp

if [ ! -f $file ];then

    if [ "$1" -eq "zh" ];then
        wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/$file
    else
        wget https://repo.anaconda.com/archive/$file
    fi

fi
# anaconda is a link on my os
if [ ! -d ~/anaconda/bin ];then
    bash $file -b -p ~/anaconda
fi

export PATH=${HOME}/anaconda/bin/:$PATH

if [ ! -d ${HOME}/anaconda/envs/py27 ];then
  conda create -y -vvv -n py27 python=2.7
fi

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
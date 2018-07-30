#!/usr/bin/env bash

apt-get -y install python-setuptools
easy_install supervisor
mkdir -p /var/log/supervisor
# create directory for child images to store configuration in
mkdir -p /etc/supervisor/conf.d
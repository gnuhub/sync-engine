#!/usr/bin/env bash
source activate py27
supervisord -c /home/syncengine3/supervisor.conf -e debug
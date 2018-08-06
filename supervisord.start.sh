#!/usr/bin/env bash
source activate py27
chmod +x /home/syncengine3/*.sh
supervisord -c /home/syncengine3/supervisor.conf -e debug
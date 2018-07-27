#usr/bin/env bash

CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH
docker-compose stop
sleep 5
docker-compose pull
docker-compose up -d

#usr/bin/env bash

CMD_PATH=$(cd `dirname $0`; pwd)
cd $CMD_PATH

docker-compose pull
docker-compose up -d

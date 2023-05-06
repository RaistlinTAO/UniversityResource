#!/bin/bash

if ([ $# -lt 1 ] || [ $# -gt 3 ]); then
  echo 'Usage: '
  echo '      ./run.sh <directory-to-map> [MODE] [MEM]'
  echo ''
  echo '  MODE is optional and must be one of "yarnmode"/"y" or "local".'
  echo '    Defaults to "local"'
  echo '  MEM is optional and specifies how much RAM is given to the main docker container, provide in the form shown in:'
  echo '   https://docs.docker.com/config/containers/resource_constraints/#limit-a-containers-access-to-memory'
  echo '    Defaults to unlimited'
  exit
fi

docker kill hue 2> /dev/null
docker kill hive-host 2> /dev/null

if [ $# -gt 1 ] && ([ $2 == 'yarnmode' ] || [ $2 == 'y' ]); then
  image=multihuntr/hive-spark:yarn-0.0.2
elif [ $# -eq 1 ] || [ $2 == 'local' ]; then
  image=multihuntr/hive-spark:0.0.2
else
  echo "Malformed MODE: $image"
  exit
fi

if [ $# -eq 3 ]; then
  docker run --rm -d -m 128m -p 8888:8888 --name hue multihuntr/hive-spark-hue
  docker run --rm -itd -m $3 -p 4040-4050:4040-4050 -p 18080:18080 -p 8088:8088 -p 9000:9000 -v "$1":/root/labfiles --name hive-host $image
else
  docker run --rm -d -p 8888:8888 --name hue multihuntr/hive-spark-hue
  docker run --rm -itd -p 4040-4050:4040-4050 -p 18080:18080 -p 8088:8088 -p 9000:9000 -v "$1":/root/labfiles --name hive-host $image
fi

docker network create huenetwork
docker network connect --alias hive-host huenetwork hive-host
docker network connect huenetwork hue

docker attach hive-host
docker kill hue
docker network remove huenetwork
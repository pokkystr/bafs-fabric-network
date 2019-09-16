#!/bin/bash

MODE=$1
shift
if [ "$MODE" == "up" ]; then
    docker-compose -f orderer-compose.yaml  up
elif [ "$MODE" == "down" ]; then
    docker-compose -f orderer-compose.yaml down --volumes --remove-orphans
    docker rm $(docker ps -a -f status=exited -q)
else 
  echo "Please input up or down"
  exit 1
fi
#!/bin/bash

MODE=$1
shift
if [ "$MODE" == "up" ]; then
    docker network create -d bridge bafs
    docker-compose -f bafs-compose.yaml  up -d
elif [ "$MODE" == "down" ]; then
    docker network rm bafs
    docker-compose -f bafs-compose.yaml down --volumes --remove-orphans
else 
  echo "Please input up or down"
  exit 1
fi
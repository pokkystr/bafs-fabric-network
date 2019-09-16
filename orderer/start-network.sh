#!/bin/bash

MODE=$1
shift
if [ "$MODE" == "up" ]; then
    docker-compose -f bafs-compose.yaml up -d
elif [ "$MODE" == "down" ]; then
    docker-compose -f bafs-compose.yaml down --volumes --remove-orphans
elif 
  exit 1
fi
#!/bin/bash

# export and replace cer compose file
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/airlineorg.oil.com/ca && ls *_sk)
export CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/airlineorg.oil.com/ca && ls *_sk)

MODE=$1
shift
if [ "$MODE" == "up" ]; then
    docker network rm airline
    docker network create -d bridge airline

    docker-compose -f airline-compose.yaml  up -d 2>&1
    echo "Docker Compose airline-Compose ... up"
    echo
    
    docker exec cli.airlineorg.oil.com ./cli-command/peer-command.sh
    echo "Docker exec cli.airlineorg.oil.com and peer comman ...Done"
    echo

elif [ "$MODE" == "down" ]; then
    docker-compose -f airline-compose.yaml down --volumes --remove-orphans
    echo "Docker exec cli.airlineorg.oil.com and peer comman ... Down"
    echo

    docker network rm airline
    docker rm $(docker ps -a -f status=exited -q)
else 
  echo "Please input up or down...."
  exit 1
fi

#!/bin/bash

# export and replace cer compose file
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/exciseorg.oil.com/ca && ls *_sk)
export CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/exciseorg.oil.com/ca && ls *_sk)

function startDockerPeer(){
    #Compose Ca Peer1 Cli
    docker-compose -f airline-compose.yaml  down
    echo "Docker Compose airline-Compose ... down"

    docker-compose -f airline-compose.yaml  up -d 2>&1
    echo "Docker Compose airline-Compose ... up"
    echo
}

function startDockerCli(){
    #Docker exec cli and peer comman
    docker exec cli.exciseorg.oil.com ./cli-command/peer-command.sh
    echo "Docker exec cli.exciseorg.oil.com and peer comman ...Done"
    echo
}

docker rm $(docker ps -a -f status=exited -q)

startDockerPeer
startDockerCli

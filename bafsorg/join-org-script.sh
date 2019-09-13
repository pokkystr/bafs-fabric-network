#!/bin/bash

# export and replace cer compose file
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.oil.com/ca && ls *_sk)
export CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.oil.com/ca && ls *_sk)

function startDockerPeer(){
    #Compose Ca Peer1 Cli
    docker-compose -f bafs-compose.yaml  down
    echo "Docker Compose bafs-Compose ... down"

    docker-compose -f bafs-compose.yaml  up -d 2>&1
    echo "Docker Compose bafs-Compose ... up"
    echo
    sleep 3
}

function startDockerCli(){
    #Docker exec cli and peer comman
    docker exec cli.bafsorg.oil.com ./cli-command/peer-command.sh
    echo "Docker exec cli.bafsorg.oil.com and peer comman ...Done"
    echo
    sleep 2
}

startDockerPeer
startDockerCli

#!/bin/bash

# export and replace cer compose file
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/ca && ls *_sk)
echo
export CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/ca && ls *_sk)

docker-compose -f bafs-compose.yaml  down
echo "Docker Compose bafs-Compose Down ...Done"
echo
sleep 1

#Compose Ca Peer1 Cli
docker-compose -f bafs-compose.yaml  up -d 2>&1
echo "Docker Compose bafs-Compose UP ...Done"
echo
sleep 1

#Docker exec cli and peer comman
docker exec cli.bafsorg.com ./cli-comman/peer-command.sh
echo "Docker exec cli and peer comman ...Done"
echo
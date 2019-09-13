#!/bin/bash

echo
docker-compose -f bafs-compose.yaml  down
echo "Docker Compose bafs-Compose Down ...Done"
echo
sleep 1

# export and replace cer compose file and Compose Ca Peer1 Cli
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/ca && ls *_sk)
export CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/ca && ls *_sk)
docker-compose -f bafs-compose.yaml  up -d 2>&1
echo "Docker Compose bafs-Compose UP ...Done"
echo
sleep 1

#Docker exec cli and peer comman
docker exec cli.bafsorg.com ./cli-command/peer-command.sh
echo "Docker exec cli and peer comman ...Done"
echo
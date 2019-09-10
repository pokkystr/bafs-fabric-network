#!/bin/bash

# export and replace cer compose file
echo "KeySK " $(cd ./channel-artifacts/crypto-config/peerOrganizations/moforg.vrt.com/ca && ls *_sk)
echo
export KTB_CA_PRIVATE_KEY=$(cd ./channel-artifacts/crypto-config/peerOrganizations/moforg.vrt.com/ca && ls *_sk)

#Compose Ca Peer1 Cli
docker-compose -f mof-compose.yaml  up -d 2>&1
echo "Docker Compose Mof-Compose ...Done"
echo
sleep 5
#Docker exec cli and peer comman
docker exec cli peer-command.sh
echo "Docker exec cli and peer comman ...Done"
echo
sleep 3

#Compose Ca Peer1 Cli
docker-compose -f rd-remote-compose.yaml  up -d 2>&1
sleep 5
#Compose Ca Peer1 Cli
docker-compose -f cd-remote-compose.yaml  up -d 2>&1
sleep 5
#Compose Ca Peer1 Cli
docker-compose -f ktb-remote-compose.yaml  up -d 2>&1
sleep 5
echo "Docker Compose Remote Peer ....Done"
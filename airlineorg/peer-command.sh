#!/bin/bash

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/moforg.vrt.com/users/Admin@moforg.vrt.com/msp
export CORE_PEER_ADDRESS=peer0.moforg.vrt.com:7051
export CORE_PEER_LOCALMSPID="moforgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/moforg.vrt.com/peers/peer0.moforg.vrt.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/vrt.com/orderers/orderer.vrt.com/msp/tlscacerts/tlsca.vrt.com-cert.pem
export ORDERER_ADDRESS=10.9.211.109:7050

export CHANNEL_NAME=channel-vrt-pp10
peer channel fetch 0 ${$CHANNEL_NAME}.block -o $ORDERER_ADDRESS -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
peer channel join -b ${$CHANNEL_NAME}.block

export CHANNEL_NAME=channel-vrt-pp10sum
peer channel fetch 0 ${$CHANNEL_NAME}.block -o $ORDERER_ADDRESS -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
peer channel join -b ${$CHANNEL_NAME}.block
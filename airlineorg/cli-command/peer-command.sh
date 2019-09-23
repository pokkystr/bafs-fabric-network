#!/bin/bash
#Config
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/airlineorg.oil.com/users/Admin@airlineorg.oil.com/msp
export CORE_PEER_LOCALMSPID="airlineorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/airlineorg.oil.com/peers/peer0.airlineorg.oil.com/tls/ca.crt

#Orderer
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/oil.com/orderers/orderer.oil.com/msp/tlscacerts/tlsca.oil.com-cert.pem
export ORDERER_ADDRESS=10.15.216.250:7050

#Param
export ANCHORS_NAME=./channel-artifacts/airlineorgmspanchors
export CHANNEL_TRADE=channel-trade-oil
export PROFILE_NAME=tradeoilchannel


function joinChannel(){

    peer channel fetch 0 ${CHANNEL_TRADE}.block -o $ORDERER_ADDRESS -c $CHANNEL_TRADE --tls --cafile $ORDERER_CA
    if [ $? -eq 1 ]; then
        echo "===================== Channel '$CHANNEL_TRADE' fetch Fail!! ===================== "
        exit 1
    fi

    peer channel join -b ${CHANNEL_TRADE}.block
    if [ $? -eq 1 ]; then
        echo "===================== Channel '$CHANNEL_TRADE' join Fail!! ===================== "
        echo
    fi

    peer channel update -o $ORDERER_ADDRESS -c $CHANNEL_TRADE -f ${ANCHORS_NAME}.tx --tls true --cafile $ORDERER_CA
    if [ $? -eq 1 ]; then
        echo "===================== Channel '$CHANNEL_TRADE' update Fail!! ===================== "
        echo
    fi
}
joinChannel

echo "===================== Channel '$CHANNEL_TRADE' is Commiting Peer . ===================== "
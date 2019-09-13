#!/bin/bash
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/users/Admin@bafsorg.com/msp
export CORE_PEER_ADDRESS=peer0.bafsorg.com:7051
export CORE_PEER_LOCALMSPID="bafsorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/peers/peer0.bafsorg.com/tls/ca.crt

export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/orderer.bafs.com/msp/tlscacerts/tlsca.orderer.bafs.com-cert.pem
export ORDERER_ADDRESS=10.146.0.4:7050

export CHANNEL_NAME=tradeoilchannel
export ANCHORS_NAME=channel-artifacts/bafsorgmspanchors

function joinChannel(){
    peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}.tx --tls true --cafile $ORDERER_CA
    echo "===================== Channel '$CHANNEL_NAME' created ===================== "
    echo
    sleep 1

    peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
    echo "===================== Channel '$CHANNEL_NAME' join ===================== "
    echo
    sleep 1

    peer channel update -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f ${ANCHORS_NAME}.tx --tls true --cafile $ORDERER_CA
    echo "===================== Channel '$CHANNEL_NAME' update ===================== "
    echo
}

joinChannel
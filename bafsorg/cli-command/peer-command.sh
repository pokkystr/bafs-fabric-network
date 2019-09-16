#!/bin/bash
#Config
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.oil.com/users/Admin@bafsorg.oil.com/msp
export CORE_PEER_ADDRESS=peer0.bafsorg.oil.com:7051
export CORE_PEER_LOCALMSPID="bafsorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.oil.com/peers/peer0.bafsorg.oil.com/tls/ca.crt

#Orderer
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/oil.com/orderers/orderer.oil.com/msp/tlscacerts/tlsca.oil.com-cert.pem
export ORDERER_ADDRESS=10.146.0.4:7050

#Param
export ANCHORS_NAME=../channel-artifacts/bafsorgmspanchors
export CHANNEL_TRADE=channel-trade-oil
export PROFILE_NAME=tradeoilchannel

function joinChannel(){
    peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_TRADE -f ../channel-artifacts/${PROFILE_NAME}.tx --tls true --cafile $ORDERER_CA
    sleep 3
    echo "===================== Channel '$CHANNEL_TRADE' create ===================== "
    echo
    
    peer channel join -b ${CHANNEL_TRADE}.block
    sleep 3
    echo "===================== Channel '$CHANNEL_TRADE' join ===================== "
    echo

    peer channel update -o $ORDERER_ADDRESS -c $CHANNEL_TRADE -f ${ANCHORS_NAME}.tx --tls true --cafile $ORDERER_CA
    echo "===================== Channel '$CHANNEL_TRADE' update ===================== "
    echo
    sleep 3
}
sleep 5
joinChannel

peer chaincode install -n bafsecc -v j.1.0 -l java -p ../channel-artifacts/chaincode/ >&log.txt
cat log.txt
echo "===================== Channel bafsecc install ===================== "
echo
peer chaincode instantiate -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_TRADE -n bafsecc -l java -v j.1.0 -c '{"Args":["init"]}' -P "AND ('bafsorgmsp.member','exciseorgmsp.member')" >&log.txt
cat log.txt
echo "===================== Channel bafsecc install ===================== "
echo

peer chaincode query -C $CHANNEL_TRADE -n bafsecc -c '{"Args":["queryInvoice","ticketNumber3"]}' >&log.txt
cat log.txt
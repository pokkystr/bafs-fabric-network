#!/bin/bash
#Config
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.oil.com/users/Admin@cdorg.oil.com/msp
export CORE_PEER_ADDRESS=peer0.cdorg.oil.com:7051
export CORE_PEER_LOCALMSPID="cdorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.oil.com/peers/peer0.cdorg.oil.com/tls/ca.crt

#Orderer
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/oil.com/orderers/orderer.oil.com/msp/tlscacerts/tlsca.oil.com-cert.pem
export ORDERER_ADDRESS=10.146.0.4:7050

#Param
export ANCHORS_NAME=./channel-artifacts/cdorgmspanchors
export CHANNEL_TRADE=channel-trade-oil
export PROFILE_NAME=tradeoilchannel

function joinChannel(){

    peer channel fetch 0 ${CHANNEL_TRADE}.block -o $ORDERER_ADDRESS -c $CHANNEL_TRADE --tls --cafile $ORDERER_CA    
    sleep 3
    echo "===================== Channel '$CHANNEL_TRADE' fetch ===================== "
    echo
    
    peer channel join -b ${CHANNEL_TRADE}.block
    sleep 3
    echo "===================== Channel '$CHANNEL_TRADE' join ===================== "
    echo
    
    peer channel update -o $ORDERER_ADDRESS -c $CHANNEL_TRADE -f ${ANCHORS_NAME}.tx --tls true --cafile $ORDERER_CA
    echo "===================== Channel '$CHANNEL_TRADE' update ===================== "
    echo
}

function installAndinstantiate(){
    peer chaincode install -n cdecc -v j.1.0 -l java -p ./channel-artifacts/chaincode/ >&installLog.txt
    cat installLog.txt
    echo "===================== Channel cdecc install ===================== "
    echo
    sleep 5

    peer chaincode instantiate -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_TRADE -n cdecc -l java -v j.1.0 -c '{"Args":["init"]}' -P "AND ('bafsorgmsp.member','exciseorgmsp.member','cdorgmsp.member')" >&instantiateLog.txt
    cat instantiateLog.txt
    echo "===================== Channel cdecc instantiate ===================== "
    echo
    sleep 5
}

joinChannel
installAndinstantiate

peer chaincode query -C $CHANNEL_TRADE -n cdecc -c '{"Args":["queryInvoice","ticketNumber3"]}' >&querylog.txt
cat querylog.txt
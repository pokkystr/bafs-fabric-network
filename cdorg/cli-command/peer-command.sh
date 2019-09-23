#!/bin/bash
#Config
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.oil.com/users/Admin@cdorg.oil.com/msp
export CORE_PEER_LOCALMSPID="cdorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.oil.com/peers/peer0.cdorg.oil.com/tls/ca.crt

#Orderer
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/oil.com/orderers/orderer.oil.com/msp/tlscacerts/tlsca.oil.com-cert.pem
export ORDERER_ADDRESS=10.15.216.250:7050

#Param
export ANCHORS_NAME=./channel-artifacts/cdorgmspanchors
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

function installAndinstantiate(){
    peer chaincode install -n invoice -v j.1.0 -l java -p /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/chaincode/
    # cat installLog.txt
    echo "===================== Channel invoice install ===================== "
    echo
    # sleep 5
    # peer chaincode instantiate -o $ORDERER_ADDRESS --tls true --cafile $ORDERER_CA -C $CHANNEL_TRADE -n invoice -l java -v j.1.2 -c '{"Args":["init"]}' -P "AND ('bafsorgmsp.member','cdorgmsp.member')"
    # # cat instantiateLog.txt
    # echo "===================== Channel invoice instantiate ===================== "
    # echo
    # sleep 3
}

joinChannel
installAndinstantiate
sleep 10

peer chaincode query -C $CHANNEL_TRADE -n invoice -c '{"Args":["queryInvoice","ticketNumber3"]}'
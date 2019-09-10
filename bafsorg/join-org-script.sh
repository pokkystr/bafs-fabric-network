export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/users/Admin@bafsorg.com/msp
export CORE_PEER_ADDRESS=peer0.bafsorg.com:7051
export CORE_PEER_LOCALMSPID="bafsorg"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/peers/peer0.bafsorg.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/ordererOrganizations/orderer.bafs.com/msp/tlscacerts/tlsca.orderer.bafs.com-cert.pem
export CHANNEL_ID=tradeoil-channel
export ORDERER_ADDRESS=34.92.224.227:7050

peer channel create -o $ORDERER_ADDRESS -c $CHANNEL_ID -f tradeOilChannel.tx --tls --cafile $ORDERER_CA
peer channel join -b $CHANNEL_ID.block
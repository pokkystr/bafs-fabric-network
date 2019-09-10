export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.vrt.com/users/Admin@cdorg.vrt.com/msp
export CORE_PEER_ADDRESS=peer0.cdorg.vrt.com:7051
export CORE_PEER_LOCALMSPID="cdorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/peerOrganizations/cdorg.vrt.com/peers/peer0.cdorg.vrt.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/crypto-config/ordererOrganizations/vrt.com/orderers/orderer.vrt.com/msp/tlscacerts/tlsca.vrt.com-cert.pem
export CHANNEL_NAME=channel-vrt-pp10
export ORDERER_ADDRESS=10.9.211.109:7050

peer channel fetch 0 channel-vrt-pp10.block -o $ORDERER_ADDRESS -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
peer channel join -b channel-vrt-pp10.block
peer channel update -o $ORDERER_ADDRESS -c $CHANNEL_NAME -f pp10cdorgmspanchors.tx --tls --cafile $ORDERER_CA
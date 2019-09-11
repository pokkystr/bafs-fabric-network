
export CORE_PEER_LOCALMSPID="bafsorgmsp"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/peers/peer0.bafsorg.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/channel-artifacts/crypto-config/peerOrganizations/bafsorg.com/users/Admin@bafsorg.com/msp
export CORE_PEER_ADDRESS=peer0.bafsorg.com:7051
export ORDERER_CA=${PWD}/channel-artifacts/crypto-config/ordererOrganizations/orderer.bafs.com/msp/tlscacerts/tlsca.orderer.bafs.com-cert.pem

export CHANNEL_ID=tradeoil-channel
export ORDERER_ADDRESS=10.146.0.4:7050


# peer channel create -o orderer.example.com:7050 -c tradeoil-channel -f ./channel-artifacts/channel.tx >&log.txt
peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt

peer channel create -o 10.146.0.4:7050 -c tradeoil-channel -f bafsorgmspanchors.tx --tls --cafile $ORDERER_CA
peer channel create -o 10.146.0.4:7050 -c tradeoil-channel -f bafsorgmspanchors.tx >&log.txt

peer channel create -o orderer.bafs.com:7050 -c tradeoil-channel -f ./channel-artifacts/bafsorgmspanchors.tx --tls --cafile $ORDERER_CA

peer channel join -b $CHANNEL_ID.block
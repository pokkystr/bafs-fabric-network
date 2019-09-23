#!/bin/bash
export PATH=${PWD}/../bin:${PWD}:$PATH

function orderer-generateCerts() {
  which cryptogen
  echo
  echo "##########################################################"
  echo "##### Orderer Generate certificates or cryptogen tool #########"
  echo "##########################################################"

  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  set -x
  cryptogen generate --config=./cryptogen.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
}

function genesisBlock-generate(){
    #Check Folder is exists
    if [ -d "channel-artifacts" ]; then
        rm -Rf channel-artifacts
    fi
    mkdir -p channel-artifacts

    configtxgen -profile BafsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
}

docker rm $(docker ps -a -f status=exited -q)

##################################################
# generate-orderer  crypto
##################################################
orderer-generateCerts
genesisBlock-generate

##################################################
# generate-channel create file block and tx then
# copy to Org Folder
##################################################
# import channel-generate.sh
. utility-generate.sh
generate-utility

cp -R ../chaincode-bafs/ ../bafsorg/channel-artifacts/chaincode/
cp -R ../chaincode-bafs/ ../exciseorg/channel-artifacts/chaincode/
cp -R ../chaincode-bafs/ ../cdorg/channel-artifacts/chaincode/
# cp -R ../chaincode-bafs/ ../airlineorg/channel-artifacts/chaincode/


# zip orderer.zip -r ../orderer
# zip bafsorg.zip -r ../bafsorg
# zip airlineorg.zip -r ../airlineorg
# zip exciseorg.zip -r ../exciseorg
# zip cdorg.zip -r ../cdorg
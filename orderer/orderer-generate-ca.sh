#!/bin/bash
export PATH=${PWD}/../bin:${PWD}:$PATH

function orderer-generateCerts() {
  which cryptogen
  echo
  echo "##########################################################"
  echo "##### Orderer Generate certificates or cryptogen tool ####"
  echo "##########################################################"

  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  set -x
  cryptogen generate --config=./crypto-confix.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
}
SYS_CHANNEL="bafs-sys-channel"
function genesisBlock-generate(){
    #Check Folder is exists
    if [ -d "channel-artifacts" ]; then
        rm -Rf channel-artifacts
    fi
    mkdir -p channel-artifacts
    configtxgen -profile BafsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block
    # configtxgen -profile BafsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
}
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

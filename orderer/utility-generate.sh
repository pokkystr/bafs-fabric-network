#!/bin/bash
export ORG_SUFFIX=msp
export CHANNEL_ID=channel-tradeoil
export CHANNEL_NAME=tradeOilChannel.tx

##################################################
# function generateCert need param 
# 1 - channelName 
# 2 - orgName(folder)
# 3 - profileName 
##################################################
function generateAnchorsCert() {
    set -x
    CHANNEL=$1
    ORG_NAME=$2
    PROFILE_NAME=$3

    ANCHORS_NAME=${ORG_NAME}${ORG_SUFFIX}anchors.tx
    configtxgen -profile $PROFILE_NAME -outputAnchorPeersUpdate ./channel-artifacts/$ANCHORS_NAME -channelID $CHANNEL -asOrg ${ORG_NAME}${ORG_SUFFIX}
    set +x
}

function checkAndCreatePeerOrg(){
    ORG_NAME=$1
    
    if [ -d ../$ORG_NAME/channel-artifacts/crypto-config/peerOrganizations/ ]; then
        rm -Rf ../$ORG_NAME/channel-artifacts/crypto-config/peerOrganizations/
    fi
        mkdir -p ../$ORG_NAME/channel-artifacts/crypto-config/peerOrganizations/
}

function checkAndCreateOrdererOrg(){
    ORG_NAME=$1
    
    if [ -d ../$ORG_NAME/channel-artifacts/crypto-config/ordererOrganizations/ ]; then
        rm -Rf ../$ORG_NAME/channel-artifacts/crypto-config/ordererOrganizations/
    fi
        mkdir -p ../$ORG_NAME/channel-artifacts/crypto-config/ordererOrganizations/
}

function copyCryptoConfigToOrganizations(){
    ORG_NAME=$1
    
    checkAndCreatePeerOrg $ORG_NAME
    cp -r ./crypto-config/peerOrganizations/$ORG_NAME.com ../$ORG_NAME/channel-artifacts/crypto-config/peerOrganizations/

    checkAndCreateOrdererOrg $ORG_NAME
    cp -r ./crypto-config/ordererOrganizations/orderer.com ../$ORG_NAME/channel-artifacts/crypto-config/ordererOrganizations/
}

function generateChannel(){
    configtxgen -profile TradeOilChannel -outputCreateChannelTx ./channel-artifacts/$CHANNEL_NAME -channelID $CHANNEL_ID
}

function createFolderChainCode(){
    ORG_NAME=$1

    if [ -d ../$ORG_NAME/channel-artifacts/ ]; then
        rm -rf ../$ORG_NAME/channel-artifacts/
    fi
    mkdir -p ../$ORG_NAME/channel-artifacts/
    mkdir -p ../$ORG_NAME/channel-artifacts/chaincode/
}

function copyAnchorsCertToOrganizations(){
    ORG_NAME=$1

    ANCHORS_NAME=${ORG_NAME}${ORG_SUFFIX}anchors.tx
    cp -rp ./channel-artifacts/$ANCHORS_NAME ../$ORG_NAME/channel-artifacts/
}

function copyChaincodeToOrganizations(){
    ORG_NAME=$1
    cp -rp ../chaincode/ ../$ORG_NAME/channel-artifacts/chaincode/
}

function replaceComposeKeySK(){
    ORG_NAME=$1

    COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_CA}"
    export KTB_CA_PRIVATE_KEY="$(cd crypto-config/peerOrganizations/org1.example.com/ca && ls *_sk)"
}

function generate-utility(){
    echo
    echo "############################################"
    echo "############# Generate channel #############"
    echo "############################################"
    generateChannel
    
    echo
    echo "############################################"
    echo "############ Generate Anchors ##############"
    echo "############################################"
    for orgName in bafsorg; do
		generateAnchorsCert $CHANNEL_ID $orgName TradeOilChannel
        sleep 1
    done

    for orgName in bafsorg; do
        createFolderChainCode $orgName 
        echo "1 - Create Folder ChainCode OrgName "$orgName" .... Done"

        copyCryptoConfigToOrganizations $orgName        
        echo "2 - Copy Folder PeerName "$orgName" .... Done"

        copyAnchorsCertToOrganizations $orgName 
        echo "3 - Copy AnchorsName "$orgName" .... Done"

        # copyChaincodeToOrganizations $orgName
        # echo "Copy Chaincode .... Done"

        # if [ "$orgName" == "rdorg" ]; then
        #     cp -rp ./channel-artifacts/$CHANNEL_NAME_PP10 ../$ORG_NAME/channel-artifacts/
        #     cp -rp ./channel-artifacts/$CHANNEL_NAME_PP10SUM ../$ORG_NAME/channel-artifacts/
        # fi
        sleep 1
        echo
    done
}
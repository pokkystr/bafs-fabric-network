#!/bin/bash
export ORG_SUFFIX=msp
export CHANNEL_ID=channel-trade-oil
export CHANNEL_NAME=tradeoilchannel

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
    cp -r ./crypto-config/peerOrganizations/$ORG_NAME.oil.com ../$ORG_NAME/channel-artifacts/crypto-config/peerOrganizations/

    checkAndCreateOrdererOrg $ORG_NAME
    cp -r ./crypto-config/ordererOrganizations/oil.com ../$ORG_NAME/channel-artifacts/crypto-config/ordererOrganizations/
}

function generateChannel(){
    configtxgen -profile TradeOilChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_ID
}

function createFolderChainCode(){
    ORG_NAME=$1

    if [ -d ../$ORG_NAME/channel-artifacts/ ]; then
        rm -rf ../$ORG_NAME/channel-artifacts/
    fi
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
    echo "#############################################"
    echo "############# Generate channel ##############"
    echo "#############################################"
    generateChannel

    # echo
    # echo "#############################################"
    # echo "########## Generate Anchors PP10 ############"
    # echo "#############################################"
    # airlineorg exciseorg cdorg
    for orgName in bafsorg ; do
		generateAnchorsCert $CHANNEL_ID $orgName TradeOilChannel
        sleep 1
    done
    # generateAnchorsCert channel-vrt-pp10 rdorg PP10Channel
# airlineorg exciseorg cdorg
    for orgName in bafsorg ; do
        createFolderChainCode $orgName 
        echo "Create Folder ChainCode OrgName "$orgName" .... Done"

        # copyChaincodeToOrganizations $orgName
        # echo "Copy Chaincode .... Done"

        copyCryptoConfigToOrganizations $orgName        
        echo "Copy Folder PeerName "$orgName" .... Done"

        copyAnchorsCertToOrganizations $orgName 
        echo "Copy AnchorsName "$orgName" .... Done"

        if [ "$orgName" == "bafsorg" ]; then
            cp -rp ./channel-artifacts/${CHANNEL_NAME}.tx ../$ORG_NAME/channel-artifacts/
        fi
        sleep 1
        echo
    done
}
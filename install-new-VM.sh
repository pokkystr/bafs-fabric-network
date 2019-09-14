#!/bin/bash

function installDocker(){
    sudo apt-get remove docker docker-engine docker.io containerd runc
    echo "####### Uninstall Docker #######"
    echo

    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    echo

    echo "Docker Status" curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    echo

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    echo
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    echo "###### install Docker Success. ########"
}

function installDockerCompose(){
    sudo apt-get update
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "###### install Docker Compose Success. ########"
}

sudo apt-get update
apt-get -y update && apt-get -y install jq
echo "Installing jq"

installDocker
installDockerCompose
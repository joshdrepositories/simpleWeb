#!/bin/bash

#define variables for use in the script (change to suit your own needs)
IMAGE_NAME="simpleweb-web"
VPS_IP=""
VPS_USERNAME=""
SSH_PRIVATE_KEY_PATH="~/.ssh/id_rsa"

#build the docker image using docker compose
docker compose build

#save the docker image to a tarball in the project directory
docker save -o $IMAGE_NAME.tar $IMAGE_NAME

#copy ssh public key to the server
ssh-copy-id $VPS_USERNAME@$VPS_IP

#ssh into the server and install rsync if not already installed
ssh -t $VPS_USERNAME@$VPS_IP \
    "sudo apt update -y && sudo apt upgrade && \
     sudo apt install rsync && \
     sudo systemctl start rsync"

#push the image to a server with rsync
rsync -avz $IMAGE_NAME.tar $VPS_USERNAME@$VPS_IP:/home/$VPS_USERNAME

#remove the tarball from the project directory
rm -rf $IMAGE_NAME.tar

#ssh into the server, install docker and run the docker image
ssh -t $VPS_USERNAME@$VPS_IP \
    "sudo apt update -y &&  sudo apt upgrade -y && \

     sudo apt install ca-certificates curl && \

     sudo install -m 0755 -d /etc/apt/keyrings && \
     
     sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
     sudo chmod a+r /etc/apt/keyrings/docker.asc && \
     echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
         sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \

     sudo apt update -y && \
     sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y && \
     sudo docker load -i $IMAGE_NAME.tar && \
     sudo rm $IMAGE_NAME.tar && \
     sudo docker run $IMAGE_NAME"

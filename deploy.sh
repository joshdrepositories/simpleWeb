#!/bin/sh

# source secret variables
. ./.env
# build docker image image
docker build -t $IMAGE_NAME:latest .
# send build image to server over ssh
docker save $IMAGE_NAME:latest | ssh -C $VPS docker load
# make directory where docker-compose.yml will live
ssh $VPS "mkdir $REMOTE_DIR/$IMAGE_NAME"
# copy docker-compose.yml to vps
rsync -avz docker-compose.yml $VPS:$REMOTE_DIR/$IMAGE_NAME/docker-compose.yml
# bring that bitch up
ssh $VPS "cd $REMOTE_DIR/$IMAGE_NAME; docker compose up -d"

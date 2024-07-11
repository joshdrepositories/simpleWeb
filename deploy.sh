#!/bin/bash
source .env
docker build -t $IMAGE_NAME:latest .
#docker save $IMAGE_NAME:latest | ssh -C $VPS docker load
ssh $VPS "mkdir $REMOTE_DIR"
rsync -avz --mkpath docker-compose.yml $VPS:$REMOTE_DIR/docker-compose.yml

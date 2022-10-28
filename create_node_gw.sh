#!/bin/bash


docker-compose -f network-docker-compose.yaml -f node-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f node-2-docker-compose.yaml up -d 

docker-compose -f network-docker-compose.yaml -f gateway-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f gateway-2-docker-compose.yaml up -d 

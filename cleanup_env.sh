#!/bin/bash
docker rm -f $(docker ps -a | grep _43 | cut -d " " -f 1)

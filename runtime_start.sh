#!/bin/bash
#Init git server
network_number=${1:-43}
ENV_DIR=.
SID=403716b0f58a7d6ddec769f8ca6008f2c1c0cea6
PARTNER_ID=fc78b64c5c33f3f270700b0c4d3e7998188035ab
docker network create -d bridge --gateway "172.24.43.1" --subnet "172.24.43.0/24"   mbr_test_network_43
docker-compose -f $ENV_DIR/git-docker-compose.yaml up -d --force-recreate
sleep 10
docker exec mbr_git_$network_number rm -rf /massbit/massbitroute/app/src/sites/services/git/data
docker exec mbr_git_$network_number rm -rf /massbit/massbitroute/app/src/sites/services/git/vars
docker exec mbr_git_$network_number /massbit/massbitroute/app/src/sites/services/git/scripts/run _repo_init
echo "export SID=$SID" > $ENV_DIR/git/data/env/api.env
echo "export PARTNER_ID=$PARTNER_ID" >> $ENV_DIR/git/data/env/api.env
docker exec -it mbr_git_$network_number /massbit/massbitroute/app/src/sites/services/git/scripts/run _repo_init
sleep 10
PRIVATE_GIT_READ=$(docker exec mbr_git_$network_number cat /massbit/massbitroute/app/src/sites/services/git/data/env/git.env  | grep GIT_PRIVATE_READ_URL  | cut -d "=" -f 2 | sed "s/'//g")
echo $PRIVATE_GIT_READ
cat $ENV_DIR/docker-compose.yaml.template | sed "s|\[\[PRIVATE_GIT_READ\]\]|$PRIVATE_GIT_READ|g" > $ENV_DIR/docker-compose.yaml
docker-compose -f $ENV_DIR/docker-compose.yaml up -d --force-recreate
cat $ENV_DIR/stat-docker-compose.yaml.template | sed "s|\[\[PRIVATE_GIT_READ\]\]|$PRIVATE_GIT_READ|g" > $ENV_DIR/stat-docker-compose.yaml
docker-compose -f $ENV_DIR/stat-docker-compose.yaml up -d --force-recreate
sleep 30
#docker exec mbr_api bash -c '/massbit/massbitroute/app/src/sites/services/api/cmd_server start nginx'
docker exec mbr_portal_api_$network_number bash -c 'cd /app; npm run dbm:init'
docker exec mbr_db_$network_number bash -c 'bash /docker-entrypoint-initdb.d/3_init_user.sh'
docker exec mbr_db_$network_number bash -c 'bash /docker-entrypoint-initdb.d/2_clean_node.sh'

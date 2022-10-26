network_number=43
docker network create -d bridge --gateway "172.24.$network_number.1" --subnet "172.24.$network_number.0/24"  mbr_test_network_$network_number

docker-compose  -f git-docker-compose.yaml up -d

sleep 10
docker exec mbr_git_$network_number rm -rf /massbit/massbitroute/app/src/sites/services/git/data/*
docker exec mbr_git_$network_number rm -rf /massbit/massbitroute/app/src/sites/services/git/vars/*
docker exec mbr_git_$network_number /massbit/massbitroute/app/src/sites/services/git/scripts/run _repo_init
export MASSBIT_ROUTE_SID=403716b0f58a7d6ddec769f8ca6008f2c1c0cea6
export MASSBIT_ROUTE_PARTNER_ID=fc78b64c5c33f3f270700b0c4d3e7998188035ab
echo "export SID=$MASSBIT_ROUTE_SID" > git/data/env/api.env
echo "export PARTNER_ID=$MASSBIT_ROUTE_PARTNER_ID" >> git/data/env/api.env

PRIVATE_GIT_READ=$(docker exec mbr_git_$network_number cat /massbit/massbitroute/app/src/sites/services/git/data/env/git.env  | grep GIT_PRIVATE_READ_URL  | cut -d "=" -f 2 | sed "s/'//g")
echo $PRIVATE_GIT_READ
cat core-docker-compose.yaml.template | sed "s|\[\[PRIVATE_GIT_READ\]\]|$PRIVATE_GIT_READ|g" > core-docker-compose.yaml
docker-compose -f network-docker-compose.yaml -f core-docker-compose.yaml -f fisherman-docker-compose.yaml -f portal-docker-compose.yaml up -d

sleep 10

docker restart mbr_portal_api_43


# docker-compose -f network.yaml -f gateway_eth_mainnet.yaml -f node_eth_mainnet.yaml  up -d 

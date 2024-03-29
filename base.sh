#!/bin/bash
export RUNTIME_DIR=/massbit/test_runtime
export network_number=$(cat .vars/network_number)
export gateway=$(cat .vars/gateway)
export node=$(cat .vars/node)
export stat=$(cat .vars/stat)
export git=$(cat .vars/git)
export chain=$(cat .vars/chain)
export fisherman=$(cat .vars/fisherman)
export staking=$(cat .vars/staking)
export portal=$(cat .vars/portal)
export web=$(cat .vars/web)
export api=$(cat .vars/api)
export gwman=$(cat .vars/gwman)
export session=$(cat .vars/session)

source .env.${TEST_ENV:-local}

export GIT_PRIVATE_BRANCH=shamu
export PROTOCOL=http
export SCHEDULER_AUTHORIZATION=SomeSecretString
export FISHER_ENVIRONMENT=local
export MASSBIT_ROUTE_SID=403716b0f58a7d6ddec769f8ca6008f2c1c0cea6
export MASSBIT_ROUTE_PARTNER_ID=fc78b64c5c33f3f270700b0c4d3e7998188035ab
export GIT_PRIVATE_BRANCH=shamu
export NETWORK_PREFIX=mbr_test_network
#IPs: 30-230: Node and gateway

export PROXY_IP=254
export TEST_CLIENT_IP=253
export CHAIN_IP=20

export PORTAL_IP=10
export WEB_IP=11
export STAKING_IP=12
export POSTGRES_IP=13
export REDIS_IP=14
export FISHERMAN_SCHEDULER_IP=15
export FISHERMAN_WORKER01_IP=16
export FISHERMAN_WORKER02_IP=17

export GWMAN_IP=2
export GIT_IP=5
export API_IP=6
export SESSION_IP=7

export START_IP=20

export MONITOR_IP=50

# if [ "x$network_number" == "x" ]; then
#   while docker network ls | grep "$find_string"
#   do
#       network_number=$(shuf -i 0-255 -n 1)
#       find_string="\"Subnet\": \"172.24.$network_number.0/24\","
#       echo $find_string
#   done
# fi
ENV=$network_number
export ENV_DIR=$RUNTIME_DIR/$ENV
export PROXY_LOGS=$ENV_DIR/proxy/logs
#init docker-compose file
echo '--------------------------'
echo '-----Init environment-----'
echo '--------------------------'
if [ ! -d "$PROXY_LOGS" ]
then
  mkdir -p $PROXY_LOGS
fi
if [ -f "$PROXY_LOGS/proxy_access.log" ]; then
  truncate -s 0 "$PROXY_LOGS/proxy_access.log"
fi
if [ -f "$PROXY_LOGS/proxy_error.log" ]; then
  truncate -s 0 "$PROXY_LOGS/proxy_error.log"
fi
export network_number=$network_number

declare -A blockchains=()
blockchains["eth"]="mainnet rinkerby"
blockchains["dot"]="mainnet"
export blockchains
export domain=massbitroute.net

### 1. Spin up core environement

```sh
bash start_env.sh
```

### 2. Append to user's pc/laptop host file `/etc/hosts`

```
[Public IP of docker host] portal.massbitroute.net
[Public IP of docker host] dapi.massbitroute.net
[Public IP of docker host] chain.massbitroute.net


```

### . Spin up docker for Massbit node/gw
```
docker-compose -f network-docker-compose.yaml -f node-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f node-2-docker-compose.yaml up -d 

docker-compose -f network-docker-compose.yaml -f gateway-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f gateway-2-docker-compose.yaml up -d 
```

### . Create SSH tunnel to connect to PolkadotJS dashboard to Massbit Chain docker

```sh
ssh -L"9944:172.24.43.20:9944" [SERVER IP]
```

### On user computer, access Polkadot JS dashboard to view chain events `https://polkadot.js.org/apps///?rpc=ws%3A%2F%2Flocalhost%3A9944#/explorer`

Notice `fisherman.NewJobResults`



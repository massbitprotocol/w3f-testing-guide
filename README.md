#### 1. Spin up core environement

```sh
bash start_env.sh
```

#### 2. Append to user's pc/laptop host file `/etc/hosts`

```
[Public IP of docker host] portal.massbitroute.net
[Public IP of docker host] dapi.massbitroute.net
[Public IP of docker host] chain.massbitroute.net


```

#### . Spin up docker for Massbit node/gw
```
docker-compose -f network-docker-compose.yaml -f node-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f node-2-docker-compose.yaml up -d 

docker-compose -f network-docker-compose.yaml -f gateway-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f gateway-2-docker-compose.yaml up -d 
```

#### . Create SSH tunnel to connect to PolkadotJS dashboard to Massbit Chain docker

```sh
ssh -L"9944:172.24.43.20:9944" [SERVER IP]
```

#### On user computer, access Polkadot JS dashboard to view chain events 

`https://polkadot.js.org/apps///?rpc=ws%3A%2F%2Flocalhost%3A9944#/explorer`

Notice `fisherman.NewJobResults`
![image](https://user-images.githubusercontent.com/6365545/192491644-a897cff3-5198-474c-ab49-19f4bb4bca8f.png)


#### . Turn off node and gateway. Offchain worker will detect and change node status to `Investigate`, which means Node/GW is no longer part of Massbit network

```
root@datnm:/massbit/test_runtime/43# docker rm gateway_43_eth_mainnet_grant-m2_2  -f
gateway_43_eth_mainnet_grant-m2_2
root@datnm:/massbit/test_runtime/43# docker rm node_43_eth_mainnet_grant-m2_2  -f
node_43_eth_mainnet_grant-m2_2
```

#### . Use sshutle to connect user's computer to docker network on server

```
sshuttle -r massbit@192.168.1.239 172.24.43.0/24 -vv
```

#### . Create/Stake Project + dAPI and test dAPI





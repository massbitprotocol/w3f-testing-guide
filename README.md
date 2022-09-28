#### 1. Spin up core environement

* Run the following command to create a docker network for Massbit Route Components. * Run `docker ps` to check the running containers. 

```sh
bash start_env.sh
```

#### 2. Append to user's pc/laptop host file `/etc/hosts`

* Append the following entryies to the host file of the Docker host `/etc/hosts`

```
[Public IP of docker host] portal.massbitroute.net
[Public IP of docker host] dapi.massbitroute.net
[Public IP of docker host] chain.massbitroute.net
[Public IP of docker host]  session.mbr.massbitroute.net
```

* Now that the Docker environment for Massbit Core components is up, we can access the Web portal through the URL http://dapi.massbitroute.net. Make sure you have a Polkadot extension wallet installed for your Chome or Brave browser to register an account with Massbit Route. Once you are registered with Massbit Route in Docker environment, the account ballance will be 1000 KEI token by default for staking.

### 3. Create docker environment for Massbit Node. We will create 2 Nodes and 2 Gateways

* In the Web Portal [Community Node Page](http://dapi.massbitroute.net/nodes), register a new Massbit Node by clicking on the "Add Node" button in one of the 6 zones in the **Zones** section


* Fill in the Massbit Node information and blockchain type. For the datasource, fill in the RPC and Websocket URL for your blockchain node. Using Alchemy, Infura, Getblock, etc. URL enpoints also work.
 
![image](https://user-images.githubusercontent.com/6365545/179483396-ede89873-42fb-4e7f-9b51-db04cf03c49f.png)

* From the Node detail page, copy the URL to the installation script, not the entire command.

![image](https://user-images.githubusercontent.com/6365545/179504774-822fc685-f2b1-4c23-8aaf-612e44d3864a.png)

* Paste the copied URL as the value for the `INSTALL_CMD` environment variable in `node-docker-compose.yaml`  file

* Create Massbit Route node container by running the following command. The container will execute the installations script and from the URL in the `INSTALL_CMD` environment variable.

*Note: Nodes and Gateways are operated by anyone around the world and will proxies dAPI traffic to the nearest Massbit node and blockchain RPC nodes attached to it.* 

#### 4. Spin up docker for Massbit node/gw
```
docker-compose -f network-docker-compose.yaml -f node-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f node-2-docker-compose.yaml up -d 

docker-compose -f network-docker-compose.yaml -f gateway-docker-compose.yaml up -d 
docker-compose -f network-docker-compose.yaml -f gateway-2-docker-compose.yaml up -d 
```

#### 5. Turn off node and gateway. Offchain worker will detect and change node status to `Investigate`, which means Node/GW is no longer part of Massbit network

```
root@datnm:/massbit/test_runtime/43# docker rm gateway_43_eth_mainnet_grant-m2_2  -f
gateway_43_eth_mainnet_grant-m2_2
root@datnm:/massbit/test_runtime/43# docker rm node_43_eth_mainnet_grant-m2_2  -f
node_43_eth_mainnet_grant-m2_2
```
#### 6. Create SSH tunnel to connect to PolkadotJS dashboard to Massbit Chain docker

```sh
ssh -L"9944:172.24.43.20:9944" [SERVER IP]
```

#### 7. On user computer, access Polkadot JS dashboard to view chain events 

`https://polkadot.js.org/apps///?rpc=ws%3A%2F%2Flocalhost%3A9944#/explorer`

Notice `fisherman.NewJobResults`
![image](https://user-images.githubusercontent.com/6365545/192491644-a897cff3-5198-474c-ab49-19f4bb4bca8f.png)


#### 8. Use sshutle to connect user's computer to docker network `172.24.43.0/24` on server

```
apt-get install sshuttle

sshuttle -r massbit@192.168.1.239 172.24.43.0/24 -vv
```

#### 9. Create/Stake Project + dAPI and test dAPI

In the web portal `http://dapi.massbitroute.net/projects`, create a new project, make sure the project is `staked`, then create a dAPI for the project

![image](https://user-images.githubusercontent.com/6365545/192678344-48af44d8-c484-4d20-9c34-ba00eba2de47.png)

#### 10. Click on the created dAPI to get the API URL

![image](https://user-images.githubusercontent.com/6365545/192678477-163005b9-807f-4763-b2ef-ba1b8edd5a46.png)

#### 11. On the VM host, perform nslookup for the dAPI host portion. 

* Due to `sshutle` does not support UDP, we will not be able to do `nslookup` from client computer through `gateway manager` running in the docker environment

```sh
# resolved the IP of the dAPI host 

nslookup [dAPI host portion] 172.24.43.2
```

#### 12. On the user's computer edit `/etc/hosts` files to include an entry for the create dAPI

```sh
[resolved IP] [API id].eth-mainnet.massbitroute.net
```

#### 13. Copy the URL and call the dAPI with the following command

```sh
./drain_session.sh [API URL]
```

* Once the API quota reached 0, the API will return error code `404`. The portal also show the API status as in active

![image](https://user-images.githubusercontent.com/6365545/192676982-9a73bfcb-fd57-4863-836f-b76197ed303a.png)

* The charts also display the request and bandwidth count when we call the API

![image](https://user-images.githubusercontent.com/6365545/192683264-41527e6c-6661-45a5-aa65-efe20c1cafdd.png)



## Unit tests

### Massbit Core API

```sh
git clone https://github.com/massbitprotocol/massbitroute.git -b shamu
cd massbitroute
./scripts/run _install_test
./scripts/run _run_test
```

### Massbit Chain

```sh
git clone https://github.com/massbitprotocol/massbitchain.git -b wf-grant
cd massbitchain
cargo test
```

### Massbit Fisherman

```sh
git clone https://github.com/massbitprotocol/massbitroute_fisherman.git -b web3-grant
cd massbitroute_fisherman
cargo install cargo-tarpaulin
sudo apt-get install libpq-dev
cargo tarpaulin -v --out Html
```


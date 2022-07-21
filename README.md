# Massbit Route testing guide

## Docker environment

### 1. Create Docker environment for core components

* Run the following command to create a docket network for Massbit Route Components


```sh
docker network create -d bridge --gateway 172.24.24.1 --subnet 172.24.24.0/24   mbr_test_network
```

* Spin up dockers containers for Massbit Route components including Massbit Chain. All Massbit Route components will be simulated using the Docker environment.

```sh
docker-compose up -d 
```

* Run `docker ps` to check the running containers. The output should look similar to the following.

```sh
CONTAINER ID   IMAGE                                              COMMAND                  CREATED             STATUS             PORTS                                           NAMES
e1a923e8f247   massbit/massbitroute_fisherman:v0.1                "supervisord -n"         6 minutes ago       Up 6 minutes       0.0.0.0:80->80/tcp, :::80->80/tcp               fisherman_scheduler-1
46a8d23a45ed   massbit/massbitroute_portal:v0.1                   "docker-entrypoint.as…"   5 hours ago         Up 5 hours         0.0.0.0:30001->30001/tcp, :::30001->30001/tcp   mbr_portal_worker-1
8c160c100057   massbit/massbitroute_portal:v0.1                   "docker-entrypoint.s…"   5 hours ago         Up 5 hours         0.0.0.0:3001->3001/tcp, :::3001->3001/tcp       mbr_portal_api-1
ed7f753599ba   massbit/massbitroute_portal:v0.1                   "docker-entrypoint.s…"   5 hours ago         Up 5 hours         0.0.0.0:3006->3006/tcp, :::3006->3006/tcp       mbr_portal_admin-1
f367dadd215b   massbit/massbitroute_git_dev:0.0.1-shamu-dev       "/usr/bin/supervisor…"   5 hours ago         Up 5 hours                                                         mbr_git
9be1f2328a1b   massbit/massbitroute_stat_dev:0.0.1-shamu-dev      "/usr/bin/supervisor…"   5 hours ago         Up 5 hours                                                         mbr_stat
bbbeca2c22d3   massbit/massbitroute_gwman_dev:0.0.1-shamu-dev     "/usr/bin/supervisor…"   5 hours ago         Up 5 hours                                                         mbr_gwman
b63f631e3744   massbit/massbitroute_web:v0.1                      "docker-entrypoint.s…"   5 hours ago         Up 5 hours         0.0.0.0:3000->3000/tcp, :::3000->3000/tcp       mbr_web-1
3fc7a9feea86   massbit/massbitroute_monitor_dev:0.0.1-shamu-dev   "/usr/bin/supervisor…"   5 hours ago         Up 5 hours                                                         mbr_monitor
5ee8a16bed16   massbit/massbitroute_api_dev:0.0.1-shamu-dev       "/usr/bin/supervisor…"   5 hours ago         Up 5 hours                                                         mbr_api
193ad587157d   redis:7.0.2-alpine                                 "docker-entrypoint.s…"   5 hours ago         Up 5 hours         0.0.0.0:6379->6379/tcp, :::6379->6379/tcp       redis-1
eb9fc0d0d46d   postgres:14.4-alpine                               "docker-entrypoint.s…"   5 hours ago         Up 5 hours         0.0.0.0:5432->5432/tcp, :::5432->5432/tcp       db-1
0b46a2e0ddec   massbit/massbitroute_chain:v0.1                    "bash entrypoint.sh"     5 days ago          Up 5 days          0.0.0.0:9944->9944/tcp, :::9944->9944/tcp       massbitchain-1

```


* Append the following entryies to the host file of the Docker host `/etc/hosts`

```sh
172.24.24.201 portal.massbitroute.net
172.24.24.200 dapi.massbitroute.net
172.24.24.205 chain.massbitroute.net
```

* Now that the Docker environment for Massbit Core components is up. We can access the Web portal through the URL http://dapi.massbitroute.net. Make sure you have a Polkadot extension wallet installed for your Chome or Brave browser to register an account with Massbit Route. Once you are registered with Massbit Route in Docker environment, the account ballance will be 1000 KEI token by default for staking.

### 2. Create docker environment for Massbit Node

* In the Web Portal [Community Node Page](http://dapi.massbitroute.net/nodes), register a new Massbit Node by clicking on the "Add Node" button in one of the 6 zones in the **Zones** section


* Fill in the Massbit Node information and blockchain type. For the datasource, fill in the RPC and Websocket URL for your blockchain node. Using Alchemy, Infura, Getblock, etc. URL enpoints also work.
 
![image](https://user-images.githubusercontent.com/6365545/179483396-ede89873-42fb-4e7f-9b51-db04cf03c49f.png)

* From the Node detail page, copy the URL to the installation script, not the entire command.

![image](https://user-images.githubusercontent.com/6365545/179504774-822fc685-f2b1-4c23-8aaf-612e44d3864a.png)

* Paste the copied URL as the value for the `INSTALL_CMD` environment variable in `docker-node/docker-compose.yaml`  file

* Create Massbit Route node container by running the following command. The container will execute the installations script and from the URL in the `INSTALL_CMD` environment variable.

*Note: Nodes and Gateways are operated by anyone around the world and will proxies dAPI traffic to the nearest Massbit node and blockchain RPC nodes attached to it.* 

```sh
cd docker-node
docker-compose up -d
```

### 3. Create docker environment for Massbit Gateway

* In the Web Portal [Community Gateway Page](http://dapi.massbitroute.net/gateways), register a new Massbit Gateway by clicking on the "Add Gateway" button in one of the 6 zones in the **Zones** section. **Make sure you select the same zone as the the Massbit Node in the previous step**

* Fill in the Massbit Gateway information and blockchain type.

![image](https://user-images.githubusercontent.com/6365545/179657099-266c1186-8956-41fb-a526-2d1301ebd3fc.png)

* Similar to Node setup steps above, from the Gateway detail page, copy the URL to the installation script, not the entire command.

* Paste the copied URL as the value for the `INSTALL_CMD` environment variable in `docker-gateway/docker-compose.yaml`  file

* Create Massbit Route Gateway container by running the following command. The container will execute the installations script and from the URL in the `INSTALL_CMD` environment variable.

```sh
cd docker-gateway
docker-compose up -d
```
### 4. Stake token for Approved Nodes/Gateway

* When your Node and Gateway docker containers start, they will go through installation, performance checks and approval process. Once the Node/Gateway is **Approved**, you can stake KEI token for them using the Web Portal.

![image](https://user-images.githubusercontent.com/6365545/180160061-5c919770-c0c6-4faf-a00f-2639dbab2fb6.png)

* Click **Staking** button next to Approved status, and input the token amount you woulk like to stake for your Node/Gateway and click "Confirm" button.

![image](https://user-images.githubusercontent.com/6365545/180161087-721e73cb-ee7a-4fe8-90ed-0cd8f1a56e8d.png)

* Make sure you are have a Polkadot extension wallet on your browser to authorize and sign the transaction.

![image](https://user-images.githubusercontent.com/6365545/180161897-ace67adf-95f2-45ba-9cd6-780698765a0f.png)

* Once the transaction completes, the status of the Node/Gateway becomes **Staked** and the node/Gateway is now part of Massbit Route network and server dAPI traffic.

![image](https://user-images.githubusercontent.com/6365545/180162783-208fbd75-2960-4dcf-8427-07197d5585a4.png)

### 5. View the nginx configuration of node and gateways to see how traffic is routed to blockchain RPC nodes.

* Run the following command on the Massbit Gateway docker container
  
```sh 
docker exec -it mbr_gateway bash
/massbit/massbitroute/app/src/sites/services/gateway/cmd_server nginx -T
```

* From the nginx configuration, we can see the Gateway will forward traffic to the a dynamic domain that contain nearby Massbit Nodes within the same zone. In this example output, the Node and Gateway are in Vietnam (Asia), so the Gateway will route traffic to `http://eth-mainnet-AS-VN.node.mbr.massbitroute.net`.

```sh
    location / {
        proxy_pass http://eth-mainnet-AS-VN.node.mbr.massbitroute.net;
        include /massbit/massbitroute/app/src/sites/services/gateway/etc/_proxy_server.conf;
        include /massbit/massbitroute/app/src/sites/services/gateway/etc/_provider_server.conf;
        include /massbit/massbitroute/app/src/sites/services/gateway/etc/_cache_server.conf;
    }

```

* Now we look at which Massbit Node in the Gateway will forward traffic to by looking at the configuration in Massbit Gateway, which is the authoritative DNS server of massbit. In this case we will see what Node will serve traffic for `http://eth-mainnet-AS-VN.node.mbr.massbitroute.net`

```sh
# open a terminal for Gateway Manager docker
docker exec -it mbr_gwman bash

# Check the DNS zone file. eth-mainnet-AS-VN.node.mbr.massbitroute.net is handled by geoip module in NGINX
cat /massbit/massbitroute/app/src/sites/services/gwman/zones/massbitroute.net  | grep AS-VN
*-AS-VN.eth-mainnet 10/10 DYNA	geoip!mbr-map-eth-mainnet/eth-mainnet-AS-VN

# Check which Massbit Node in AS-VN. We can see the node created previously is included in ÁS-VN. 
cat /massbit/massbitroute/app/src/sites/services/gwman/data/conf.d/geolocation.d/dcmap/eth-mainnet-AS-VN
  c57973b5-3bdb-4e96-a948-82b4421eb50d =>  [ 172.24.24.3 , 1000000 ],


```

* Run the following command on the Massbit Node docker container
  
```sh 
docker exec -it mbr_node bash
/massbit/massbitroute/app/src/sites/services/node/cmd_server nginx -T
```
* From the nginx configuration, we can see the Nodes will forward traffic to the blockchain RPC address you input when creating Massbit Node on the Web Portal

```sh 
...
server {
    include /massbit/massbitroute/app/src/sites/services/node/etc/_pre_server_ws.conf;
    include /massbit/massbitroute/app/src/sites/services/node/etc/_ssl_node.mbr.massbitroute.net.conf;
    server_name ws-71621a09-b28f-4eb3-ba33-de260c39a13b.node.mbr.massbitroute.net;
    location / {
        add_header X-Mbr-Node-Id 71621a09-b28f-4eb3-ba33-de260c39a13b;
        vhost_traffic_status_filter_by_set_key $api_method user::828dcc18-49d1-4487-8a71-20a3efe59f19::node::71621a09-b28f-4eb3-ba33-de260c39a13b::v1::api_method;
        proxy_pass http://34.x.x.x:8546;
        include /massbit/massbitroute/app/src/sites/services/node/etc/_node_server_ws.conf;
    }
    location /__internal_status_vhost/ {
        include /massbit/massbitroute/app/src/sites/services/node/etc/_vts_server_ws.conf;
    }
    include /massbit/massbitroute/app/src/sites/services/node/etc/_location_server_ws.conf;
}

server {
    include /massbit/massbitroute/app/src/sites/services/node/etc/_pre_server.conf;
    include /massbit/massbitroute/app/src/sites/services/node/etc/_ssl_node.mbr.massbitroute.net.conf;
    server_name 71621a09-b28f-4eb3-ba33-de260c39a13b.node.mbr.massbitroute.net;
    location / {
        add_header X-Mbr-Node-Id 71621a09-b28f-4eb3-ba33-de260c39a13b;
        vhost_traffic_status_filter_by_set_key $api_method user::828dcc18-49d1-4487-8a71-20a3efe59f19::node::71621a09-b28f-4eb3-ba33-de260c39a13b::v1::api_method;
        proxy_pass http://34.x.x.x:8545;
        include /massbit/massbitroute/app/src/sites/services/node/etc/_node_server.conf;
    }
    location /__internal_status_vhost/ {
        include /massbit/massbitroute/app/src/sites/services/node/etc/_vts_server.conf;
    }
    include /massbit/massbitroute/app/src/sites/services/node/etc/_location_server.conf;
}

```

## Testnet environment

* Please following these guides to run Node and Gateways in Massbit Route testnet

  - [Hơw to run Massbit Node](https://docs.massbit.io/massbit-route-mbr/guides/testnet-how-to-run-massbit-node)
  - [Hơw to run Massbit Gateway](https://docs.massbit.io/massbit-route-mbr/guides/testnet-how-to-run-massbit-gateway)


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
git clone https://github.com/massbitprotocol/massbitchain.git 
cd massbitchain
cargo test
```

### Massbit Fisherman

```sh
git clone https://github.com/massbitprotocol/massbitroute_fisherman.git
cd massbitroute_fisherman
cargo install cargo-tarpaulin
cargo tarpaulin -v
```

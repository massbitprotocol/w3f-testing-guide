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

* Now that the Docker environment for Massbit Core components is up. We can access the Web portal through the URL http://dapi.massbitroute.net. Make sure you have a Polkadot extension wallet installed for your Chome or Brave browser to register an account with Massbit Route.

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

### 3. Create docker environment for Massbit Node

* In the Web Portal [Community Gateway Page](http://dapi.massbitroute.net/gateways), register a new Massbit Gateway by clicking on the "Add Gateway" button in one of the 6 zones in the **Zones** section

* Fill in the Massbit Gateway information and blockchain type.

![image](https://user-images.githubusercontent.com/6365545/179657099-266c1186-8956-41fb-a526-2d1301ebd3fc.png)

* Similar to Node setup steps above, from the Gateway detail page, copy the URL to the installation script, not the entire command.

* Paste the copied URL as the value for the `INSTALL_CMD` environment variable in `docker-gateway/docker-compose.yaml`  file

* Create Massbit Route Gateway container by running the following command. The container will execute the installations script and from the URL in the `INSTALL_CMD` environment variable.

```sh
cd docker-gateway
docker-compose up -d
```

#### 4. Create Massbit dAPI


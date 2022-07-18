# Massbit Route testing guide

## Docker environment

### Run the following command to create a docket network for Massbit Route Components



```sh
docker network create -d bridge --gateway 172.24.24.1 --subnet 172.24.24.0/24   mbr_test_network
```

### Spin up dockers containers for Massbit Route components including Massbit Chain. All Massbit Route components will be simulated using the Docker environment.

```sh
docker-compose up -d 
```

### Append the following entryies to the host file of the Docker host `/etc/hosts`

```sh
172.24.24.201 portal.massbitroute.net
172.24.24.200 dapi.massbitroute.net
172.24.24.205 chain.massbitroute.net
```

- Now that the Docker environment for Massbit Core components is up. We can access the W



- Create Massbit Route node container and run the installation script  This components is operated by anyone around the world and will proxies dAPI traffic to blockchain RPC nodes attached to it. 

```sh

```

- 
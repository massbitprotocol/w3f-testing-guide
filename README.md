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

### . Spin up docker for Massbit node
```
docker-compose -f network-docker-compose.yaml -f node-docker-compose.yaml up -d 
```

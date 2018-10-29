# dataverse-irdconfig
Dataverse dev env, with IRD config

This repository includes submodules, to clone:

```
git clone ...
git submodule update --init --recursive
```

To pull:

```
git pull
git submodule update --recursive --remote
```


## Requirements

`docker, docker-compose, maven`

## Makefile targets

```
$ make help
up                   Create and start containers
stop                 Stop containers
down                 Drop containers and volumes
build                Build builded dataverse
deploy               Deploy dataverse
config               Run config scripts
clean                Cleanup build dir
shell                Open an interactive shell in dataverse container
shelldb              Open psql client in postgresql container
logs                 Print and follow dataverse logs
help                 this help
```
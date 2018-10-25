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

- `up`: start-up dataverse with last official release
- `stop`: stop...
- `down`: clean containers and volumes
- `build`: use maven to build dataverse
- `deploy`: deploy builded dataverse into glassfish
- `config`: apply IRD config
- `shell`: open an interactive shell in dataverse container
- `clean`: cleanup maven target dir

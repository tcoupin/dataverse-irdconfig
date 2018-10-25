# dataverse-irdconfig
Dataverse dev env, with IRD config

Requirements: docker, docker-compose, maven

Makefile targets:

- `up`: start-up dataverse with last official release
- `stop`: stop...
- `down`: clean containers and volumes
- `build`: use maven to build dataverse
- `deploy`: deploy builded dataverse into glassfish
- `config`: apply IRD config
- `shell`: open an interactive shell in dataverse container
- `clean`: cleanup maven target dir

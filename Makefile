.PHONY: up stop down build deploy config clean shell shelldb logs

up: ## Create and start containers
	docker-compose up -d
stop: ## Stop containers
	docker-compose stop
down: ## Drop containers and volumes
	docker-compose down -v

build: ## Build builded dataverse
	docker-compose exec builder mvn -DskipTests package

deploy: ## Deploy dataverse
	docker-compose exec dataverse bash /dataverse-ird/config/reDeploy.sh '/dataverse-ird/dataverse/target/dataverse*.war'

config: ## Run config scripts
	docker-compose exec dataverse bash /dataverse-ird/config/configMe.sh

clean: ## Cleanup build dir
	docker-compose exec builder rm -rf target

shell: ## Open an interactive shell in dataverse container
	docker-compose exec dataverse bash
shelldb: ## Open psql client in postgresql container
	docker-compose exec -u postgres postgres psql dvndb
logs: ## Print and follow dataverse logs
	docker-compose exec dataverse tail -f /opt/glassfish4/glassfish/domains/domain1/logs/server.log

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

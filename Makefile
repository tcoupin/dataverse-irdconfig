.PHONY: up stop down build deploy config clean shell

up:
	docker-compose up -d
stop:
	docker-compose stop
down:
	docker-compose down -v

build:
	cd dataverse && mvn -DskipTests package

deploy:
	docker-compose exec dataverse bash /dataverse-ird/config/reDeploy.sh '/dataverse-ird/dataverse/target/dataverse*.war'

config:
	docker-compose exec dataverse bash /dataverse-ird/config/configMe.sh

clean:
	rm -rf dataverse/target

shell:
	docker-compose exec dataverse bash

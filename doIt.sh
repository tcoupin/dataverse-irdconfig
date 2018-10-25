#!/bin/bash
source $(dirname $0)/utils.sh

updateJVMOption dataverse.fqdn localhost
updateJVMOption dataverse.siteUrl http://localhost:8080


# Config dropdown language in header
curl http://localhost:8080/api/admin/settings/:Languages -X PUT -d '[{ "locale":"en", "title":"English"}, { "locale":"fr", "title":"Français"}]'


# DOI
echo
read -p "Datacite username:" DATACITE_USERNAME
read -s -p "Datacite password:"  DATACITE_PASSWORD
echo
updateJVMOption doi.baseurlstring https://mds.datacite.org/

if [[ "$DATACITE_USERNAME" != "" ]]
then
    updateJVMOption doi.username $DATACITE_USERNAME
    updateJVMOption doi.password $DATACITE_PASSWORD
fi

curl -X PUT -d DataCite http://localhost:8080/api/admin/settings/:DoiProvider
curl -X PUT -d doi http://localhost:8080/api/admin/settings/:Protocol
curl -X PUT -d 10.5072 http://localhost:8080/api/admin/settings/:Authority
curl -X PUT -d FK2/ http://localhost:8080/api/admin/settings/:Shoulder

# Metadatablocks
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/citation.csv -H "Content-type: text/tab-separated-values"
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/geospatial.tsv -H "Content-type: text/tab-separated-values"


echo
echo "Please restart domain1"
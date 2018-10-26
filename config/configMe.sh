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
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/citation.tsv -H "Content-type: text/tab-separated-values"
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/geospatial.tsv -H "Content-type: text/tab-separated-values"


# Branding
curl -X PUT -d  "$(dirname $0)/data/homePage.html" http://localhost:8080/api/admin/settings/:HomePageCustomizationFile

mkdir -p /opt/glassfish4/glassfish/domains/domain1/docroot/logos/navbar/
cp -f $(dirname $0)/data/logo_IRD.png /opt/glassfish4/glassfish/domains/domain1/docroot/logos/navbar/logo.png
curl -X PUT -d '/logos/navbar/logo.png' http://localhost:8080/api/admin/settings/:LogoCustomizationFile

curl -X PUT -d "$(dirname $0)/data/header.html" http://localhost:8080/api/admin/settings/:HeaderCustomizationFile

curl -X PUT -d 'true' http://localhost:8080/api/admin/settings/:DisableRootDataverseTheme # ne pas afficher le nom, le logo du dataverse root

curl -X PUT -d "$(dirname $0)/data/footer.html" http://localhost:8080/api/admin/settings/:FooterCustomizationFile

echo

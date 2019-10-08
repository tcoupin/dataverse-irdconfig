#!/bin/bash
source $(dirname $0)/utils.sh

updateJVMOption dataverse.fqdn localhost
updateJVMOption dataverse.siteUrl http://localhost:8080

asadmin set-log-levels edu.harvard.iq.dataverse=FINE

# Config dropdown language in header
mkdir -p /local_language
rm -rf /local_language/*

LANGUAGE="fr_FR en_US"
for lang in $LANGUAGE; do
    lang_dir=$(find /language/ -name $lang -printf "%d %p\n"|sort -n | tail -n 1 | awk '{print $2}')
    find $lang_dir -name "*.properties"
    find $lang_dir -name "*.properties" -exec cp {} /local_language \;
done
updateJVMOption dataverse.lang.directory /local_language
curl http://localhost:8080/api/admin/settings/:Languages -X PUT -d '[{ "locale":"fr", "title":"Français"},{ "locale":"en", "title":"English"}]'
echo

# DOI
echo "Datacite test platform credentials (doi.test.datacite.org)"
read -p "Datacite username:" DATACITE_USERNAME
read -s -p "Datacite password:"  DATACITE_PASSWORD
read -p "Datacite prefix:" DATACITE_PREFIX
echo

updateJVMOption doi.baseurlstring https://mds.test.datacite.org/

if [[ "$DATACITE_USERNAME" != "" ]]
then
    updateJVMOption doi.username $DATACITE_USERNAME
    updateJVMOption doi.password $DATACITE_PASSWORD
    curl -X PUT -d $DATACITE_PREFIX http://localhost:8080/api/admin/settings/:Authority
fi

curl -X PUT -d DataCite http://localhost:8080/api/admin/settings/:DoiProvider
curl -X PUT -d doi http://localhost:8080/api/admin/settings/:Protocol
curl -X PUT -d DVLOCAL/ http://localhost:8080/api/admin/settings/:Shoulder

# Metadatablocks
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/citation-tnu.tsv -H "Content-type: text/tab-separated-values"
curl http://localhost:8080/api/admin/datasetfield/load -X POST --data-binary @$(dirname $0)/data/geospatial.tsv -H "Content-type: text/tab-separated-values"
exit
# Add role publisher
curl -H "Content-type:application/json" -d @$(dirname $0)/data/role-publisher.json http://localhost:8080/api/admin/roles/

# Branding
#curl -X PUT -d  "$(dirname $0)/data/homePage.html" http://localhost:8080/api/admin/settings/:HomePageCustomizationFile

# CSS
curl -X PUT -d "$(dirname $0)/data/style.css" http://localhost:8080/api/admin/settings/:StyleCustomizationFile

mkdir -p /opt/glassfish4/glassfish/domains/domain1/docroot/logos/navbar/
cp -f $(dirname $0)/data/logo_IRD.png /opt/glassfish4/glassfish/domains/domain1/docroot/logos/navbar/logo.png
curl -X PUT -d '/logos/navbar/logo.png' http://localhost:8080/api/admin/settings/:LogoCustomizationFile

#curl -X PUT -d "$(dirname $0)/data/header.html" http://localhost:8080/api/admin/settings/:HeaderCustomizationFile

#curl -X PUT -d 'true' http://localhost:8080/api/admin/settings/:DisableRootDataverseTheme # ne pas afficher le nom, le logo du dataverse root

#curl -X PUT -d "$(dirname $0)/data/footer.html" http://localhost:8080/api/admin/settings/:FooterCustomizationFile

curl -X PUT -d " - <a href='https://www.ird.fr' target='_blank'>IRD - Institut de recherche pour le développement - FRANCE</a>" http://localhost:8080/api/admin/settings/:FooterCopyright

VERSION=$(cat $(dirname $0)/../dataverse/pom.xml| grep '<version>' | head -n 1 | sed "s#^[^>]*>##g" | sed 's#<[^<]*$##g' | sed 's#-IRD[0-9]*##g')
curl -X PUT -d "$VERSION" http://localhost:8080/api/admin/settings/:GuidesVersion

#NavbarAbout URL ?
#StatusMessageHeader
curl -X PUT -d "For testing only..." http://localhost:8080/api/admin/settings/:StatusMessageHeader
#StatusMessageText
curl -X PUT -d "This appears in a popup." http://localhost:8080/api/admin/settings/:StatusMessageText
#:NavbarAboutUrl
curl -X PUT -d https://data.ird.fr http://localhost:8080/api/admin/settings/:NavbarAboutUrl

curl -X PUT -d https://data.ird.fr http://localhost:8080/api/admin/settings/:ApplicationPrivacyPolicyUrl

curl -X POST -H 'Content-type: application/json' http://localhost:8080/api/admin/authenticationProviders -d '{"id":"shib","factoryAlias":"shib","enabled":true}'

curl -X PUT -d 'Administrateur des donnees IRD <data@ird.fr>' http://localhost:8080/api/admin/settings/:SystemEmail

echo

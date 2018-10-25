#!/bin/bash

DATAVERSE_APP=$(asadmin list-applications | grep dataverse | awk '{print $1}')
if [[ "$DATAVERSE_APP" != "" ]]
then
    asadmin undeploy $DATAVERSE_APP
fi

asadmin deploy $1
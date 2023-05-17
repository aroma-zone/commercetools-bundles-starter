#!/usr/bin/env bash

# This script is used to configure the CT environment for the application.
CLIENT_ID="CLIENT_ID"
CLIENT_SECRET="CLIENT_SECRET"
REGION="europe-west1.gcp"
PROJECT_KEY="aromazone-dev"
PRODUCT_TYPE_KEY="static-bundle-parent"
PRODUCT_TYPE_VERSION="11"

RESPONSE=$(curl https://auth.${REGION}.commercetools.com/oauth/token \
     --basic --user "${CLIENT_ID}:${CLIENT_SECRET}" \
     -X POST \
     -d "grant_type=client_credentials&scope=manage_project:${PROJECT_KEY} manage_api_clients:${PROJECT_KEY}")

BEARER_TOKEN=$(echo $RESPONSE | awk -F'"' '/access_token/{print $4}')

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/product-types/key=${PRODUCT_TYPE_KEY} -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "version" : ${PRODUCT_TYPE_VERSION},
  "actions" : [{
    "action" : "addAttributeDefinition",
    "attribute" : {
        "type" : {
          "name" : "lenum",
          "values" : [
            {
              "key" : "Bundle",
              "label" : {
                "en" : "Bundle",
                "it" : "Bundle",
                "fr" : "Kit"
              }
            },
            {
              "key" : "Routine",
              "label" : {
                "en" : "Routine",
                "it" : "Routine",
                "fr" : "Routine"
              }
            }
          ]
        },
        "name" : "product-label",
        "label" : {
          "en" : "Product Label",
          "fr" : "Label Produit"
        },
        "isRequired" : false,
        "attributeConstraint" : "SameForAll",
        "isSearchable" : true
    }
  }]
}
DATA
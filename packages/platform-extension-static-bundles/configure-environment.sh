#!/usr/bin/env bash

# This script is used to configure the CT environment for the application.
CLIENT_ID="CLIENT_ID"
CLIENT_SECRET="CLIENT_SECRET"
REGION="europe-west1.gcp"
PROJECT_KEY="PROJECT_KEY"

RESPONSE=$(curl https://auth.${REGION}.commercetools.com/oauth/token \
     --basic --user "${CLIENT_ID}:${CLIENT_SECRET}" \
     -X POST \
     -d "grant_type=client_credentials&scope=manage_project:${PROJECT_KEY} manage_api_clients:${PROJECT_KEY}")

BEARER_TOKEN=$(echo $RESPONSE | awk -F'"' '/access_token/{print $4}')

RESPONSE_CHILD=$(curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/product-types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "name": "StaticBundleChildVariant",
  "description": "The product variant included in a static bundle",
  "classifier": "Complex",
  "attributes": [
    {
      "name": "quantity",
      "label": {
        "en": "Quantity"
      },
      "isRequired": true,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "sku",
      "label": {
        "en": "SKU"
      },
      "isRequired": false,
      "type": {
        "name": "text"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "variant-id",
      "label": {
        "en": "Variant ID"
      },
      "isRequired": true,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "product-ref",
      "label": {
        "en": "Product"
      },
      "isRequired": false,
      "type": {
        "name": "reference",
        "referenceTypeId": "product"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "product-name",
      "label": {
        "en": "Product Name"
      },
      "isRequired": false,
      "type": {
        "name": "ltext"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    }
  ],
  "key": "static-bundle-child-variant"
}
DATA)

CHILD_ID=$(echo $RESPONSE_CHILD | perl -nle 'print $1 if m{"id":"(.*?)"[^\\]}')

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/product-types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "name": "StaticBundleParent",
  "description": "A static bundle of product variants",
  "classifier": "Complex",
  "attributes": [
    {
      "name": "products",
      "label": {
        "en": "Products"
      },
      "isRequired": false,
      "type": {
        "name": "set",
        "elementType": {
          "name": "nested",
          "typeReference": {
            "typeId": "product-type",
            "id": "${CHILD_ID}"
          }
        }
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "productSearch",
      "label": {
        "en": "Products (Search)"
      },
      "isRequired": false,
      "type": {
        "name": "set",
        "elementType": {
          "name": "text"
        }
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    }
  ],
  "key": "static-bundle-parent"
}
DATA

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "key": "static-bundle-parent-child-link",
  "name": {
    "en": "StaticBundleParentChildLink"
  },
  "description": {
    "en": "Link to a parent static bundle product by custom ID"
  },
  "resourceTypeIds": [
    "line-item",
    "custom-line-item"
  ],
  "fieldDefinitions": [
    {
      "name": "external-id",
      "label": {
        "en": "External ID"
      },
      "required": false,
      "type": {
        "name": "String"
      },
      "inputHint": "SingleLine"
    },
    {
      "name": "parent",
      "label": {
        "en": "Parent External ID"
      },
      "required": false,
      "type": {
        "name": "String"
      },
      "inputHint": "SingleLine"
    }
  ]
}
DATA

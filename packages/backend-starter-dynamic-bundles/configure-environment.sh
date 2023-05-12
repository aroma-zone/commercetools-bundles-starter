#!/usr/bin/env bash

# This script is used to configure the CT environment for the application.
CLIENT_ID="CLIENT_ID"
CLIENT_SECRET="CLIENT_SECRET"
REGION="europe-west1.gcp"
PROJECT_KEY="PROJECT_KEY"

response=$(curl https://auth.${REGION}.commercetools.com/oauth/token \
     --basic --user "${CLIENT_ID}:${CLIENT_SECRET}" \
     -X POST \
     -d "grant_type=client_credentials&scope=manage_project:${PROJECT_KEY} manage_api_clients:${PROJECT_KEY}")

BEARER_TOKEN=$(echo $response | awk -F'"' '/access_token/{print $4}')

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "key": "dynamic-bundle-parent-child-link",
  "name": {
    "en": "DynamicBundleParentChildLink"
  },
  "description": {
    "en": "Link to a parent dynamic bundle product by custom ID"
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

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "name": "DynamicBundleChildCategory",
  "description": "The category included in a dynamic bundle",
  "classifier": "Complex",
  "attributes": [
    {
      "name": "category-ref",
      "label": {
        "en": "Category Ref"
      },
      "isRequired": true,
      "type": {
        "name": "reference",
        "referenceTypeId": "category"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "min-quantity",
      "label": {
        "en": "Minimum Quantity"
      },
      "isRequired": false,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "max-quantity",
      "label": {
        "en": "Maximum Quantity"
      },
      "isRequired": false,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "additional-charge",
      "label": {
        "en": "Additional Charge"
      },
      "isRequired": false,
      "type": {
        "name": "boolean"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "category-path",
      "label": {
        "en": "Category Path"
      },
      "isRequired": true,
      "type": {
        "name": "text"
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    }
  ],
  "key": "dynamic-bundle-child-category"
}
DATA

curl https://api.${REGION}.commercetools.com/${PROJECT_KEY}/types -i \
--header "Authorization: Bearer ${BEARER_TOKEN}" \
--header 'Content-Type: application/json' \
--data-binary @- << DATA
{
  "name": "DynamicBundleParent",
  "description": "A dynamic bundle of product categories",
  "classifier": "Complex",
  "attributes": [
    {
      "name": "categories",
      "label": {
        "en": "Categories"
      },
      "isRequired": false,
      "type": {
        "name": "set",
        "elementType": {
          "name": "nested",
          "typeReference": {
            "typeId": "product-type",
            "id": "<ID of dynamic-bundle-child-category product type goes here>"
          }
        }
      },
      "attributeConstraint": "None",
      "isSearchable": false,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "min-quantity",
      "label": {
        "en": "Minimum Quantity"
      },
      "isRequired": false,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "max-quantity",
      "label": {
        "en": "Maximum Quantity"
      },
      "isRequired": false,
      "type": {
        "name": "number"
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "dynamic-price",
      "label": {
        "en": "Dynamic Price"
      },
      "isRequired": false,
      "type": {
        "name": "boolean"
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    }
  ],
  "key": "dynamic-bundle-parent"
}
DATA

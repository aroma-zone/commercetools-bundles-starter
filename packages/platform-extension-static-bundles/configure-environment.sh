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
    },
    {
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
        }]
      },
      "name" : "product-label",
      "label" : {
        "en" : "Product Label",
        "fr" : "Label Produit"
      },
        "isRequired" : false,
        "attributeConstraint" : "SameForAll",
        "isSearchable" : true
    },
    {
      "name": "best-seller",
      "label": {
        "en": "Bestseller",
        "fr": "Bestseller",
        "it": "Bestseller"
      },
      "isRequired": false,
      "type": {
        "name": "boolean"
      },
      "attributeConstraint": "SameForAll",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name": "is-sellable",
      "label": {
        "en": "Is sellable",
        "fr": "Disponible en vente",
        "it": "Is sellable"
      },
      "isRequired": true,
      "type": {
        "name": "lenum",
        "values": [
        {
          "key": "InStock",
          "label": {
            "en": "In Stock",
            "fr": "En stock",
            "it": "Rupture de stock"
          }
        },
        {
          "key": "OutOfStock",
          "label": {
            "en": "Out of Stock",
            "fr": "Out of Stock",
            "it": "Out of Stock"
          }
        },
        {
          "key": "NotAvailable",
          "label": {
            "en": "Not Available",
            "fr": "Indisponible",
            "it": "Non disponibile"
          }
        }]
      },
      "attributeConstraint": "None",
      "isSearchable": true,
      "inputHint": "SingleLine",
      "displayGroup": "Other"
    },
    {
      "name":"available-in-countries",
      "label":{
        "en":"Available in countries",
        "fr":"Disponible dans les pays",
        "it":"Disponibile nei paesi"
      },
      "isRequired":false,
      "type":{
        "name":"set",
        "elementType":{
          "name":"lenum",
          "values":[
            {
              "key":"ALL",
              "label":{
                "en":"Available in all countries",
                "fr":"Disponible dans tous les pays",
                "it":"Disponibile in tutti i paesi"
              }
            },
            {
              "key":"AD",
              "label":{
                "en":"Andorra",
                "fr":"Andorre",
                "it":"Andorra"
              }
            },
            {
              "key":"AE",
              "label":{
                "en":"United Arab Emirates",
                "fr":"Émirats Arabes Unis",
                "it":"Emirati Arabi Uniti"
              }
            },
            {
              "key":"AG",
              "label":{
                "en":"Antigua and Barbuda",
                "fr":"Antigua-et-Barbuda",
                "it":"Antigua e Barbuda"
              }
            },
            {
              "key":"AI",
              "label":{
                "en":"Anguilla",
                "fr":"Anguilla",
                "it":"Anguilla"
              }
            },
            {
              "key":"AF",
              "label":{
                "en":"Afghanistan",
                "fr":"Afghanistan",
                "it":"Afghanistan"
              }
            },
            {
              "key":"AL",
              "label":{
                "en":"Albania",
                "fr":"Albanie",
                "it":"Albania"
              }
            },
            {
              "key":"AM",
              "label":{
                "en":"Armenia",
                "fr":"Arménie",
                "it":"Armenia"
              }
            },
            {
              "key":"AN",
              "label":{
                "en":"Angola",
                "fr":"Angola",
                "it":"Angola"
              }
            },
            {
              "key":"AO",
              "label":{
                "en":"Antarctica",
                "fr":"Antarctique",
                "it":"Antartide"
              }
            },
            {
              "key":"AQ",
              "label":{
                "en":"Argentina",
                "fr":"Argentine",
                "it":"Argentina"
              }
            },
            {
              "key":"AR",
              "label":{
                "en":"American Samoa",
                "fr":"Samoa américaines",
                "it":"Samoa Americane"
              }
            },
            {
              "key":"AS",
              "label":{
                "en":"Austria",
                "fr":"Autriche",
                "it":"Austria"
              }
            },
            {
              "key":"AT",
              "label":{
                "en":"Australia",
                "fr":"Australie",
                "it":"Australia"
              }
            },
            {
              "key":"AU",
              "label":{
                "en":"Aruba",
                "fr":"Aruba",
                "it":"Aruba"
              }
            },
            {
              "key":"AW",
              "label":{
                "en":"Åland Islands",
                "fr":"Îles Åland",
                "it":"Isole Åland"
              }
            },
            {
              "key":"AX",
              "label":{
                "en":"Azerbaijan",
                "fr":"Azerbaïdjan",
                "it":"Azerbaigian"
              }
            },
            {
              "key":"AZ",
              "label":{
                "en":"Bosnia and Herzegovina",
                "fr":"Bosnie-Herzégovine",
                "it":"Bosnia ed Erzegovina"
              }
            },
            {
              "key":"BA",
              "label":{
                "en":"Barbados",
                "fr":"Barbade",
                "it":"Barbados"
              }
            },
            {
              "key":"BB",
              "label":{
                "en":"Bangladesh",
                "fr":"Bangladesh",
                "it":"Bangladesh"
              }
            },
            {
              "key":"BD",
              "label":{
                "en":"Belgium",
                "fr":"Belgique",
                "it":"Belgio"
              }
            },
            {
              "key":"BE",
              "label":{
                "en":"Burkina Faso",
                "fr":"Burkina Faso",
                "it":"Burkina Faso"
              }
            },
            {
              "key":"BF",
              "label":{
                "en":"Bulgaria",
                "fr":"Bulgarie",
                "it":"Bulgaria"
              }
            },
            {
              "key":"BG",
              "label":{
                "en":"Bahrain",
                "fr":"Bahreïn",
                "it":"Bahrein"
              }
            },
            {
              "key":"BH",
              "label":{
                "en":"Burundi",
                "fr":"Burundi",
                "it":"Burundi"
              }
            },
            {
              "key":"BI",
              "label":{
                "en":"Benin",
                "fr":"Bénin",
                "it":"Benin"
              }
            },
            {
              "key":"BJ",
              "label":{
                "en":"Saint Barthélemy",
                "fr":"Saint-Barthélemy",
                "it":"Saint-Barthélemy"
              }
            },
            {
              "key":"BL",
              "label":{
                "en":"Bermuda",
                "fr":"Bermudes",
                "it":"Bermuda"
              }
            },
            {
              "key":"BM",
              "label":{
                "en":"Brunei Darussalam",
                "fr":"Brunei Darussalam",
                "it":"Brunei"
              }
            },
            {
              "key":"BN",
              "label":{
                "en":"Bolivia",
                "fr":"Bolivie",
                "it":"Bolivia"
              }
            },
            {
              "key":"BO",
              "label":{
                "en":"Bonaire, Sint Eustatius and Saba",
                "fr":"Bonaire, Sint Eustatius and Saba",
                "it":"Isole BES"
              }
            },
            {
              "key":"BQ",
              "label":{
                "en":"Caribbean Netherlands",
                "fr":"Pays-Bas caribéens",
                "it":"Caraibi Paesi Bassi"
              }
            },
            {
              "key":"BR",
              "label":{
                "en":"Brazil",
                "fr":"Brésil",
                "it":"Brasile"
              }
            },
            {
              "key":"BS",
              "label":{
                "en":"Bahamas",
                "fr":"Bahamas",
                "it":"Bahamas"
              }
            },
            {
              "key":"BT",
              "label":{
                "en":"Bhutan",
                "fr":"Bhoutan",
                "it":"Bhutan"
              }
            },
            {
              "key":"BV",
              "label":{
                "en":"Bouvet Island",
                "fr":"Île Bouvet",
                "it":"Isola Bouvet"
              }
            },
            {
              "key":"BW",
              "label":{
                "en":"Botswana",
                "fr":"Botswana",
                "it":"Botswana"
              }
            },
            {
              "key":"BY",
              "label":{
                "en":"Belarus",
                "fr":"Biélorussie",
                "it":"Bielorussia"
              }
            },
            {
              "key":"BZ",
              "label":{
                "en":"Belize",
                "fr":"Belize",
                "it":"Belize"
              }
            },
            {
              "key":"CA",
              "label":{
                "en":"Canada",
                "fr":"Canada",
                "it":"Canada"
              }
            },
            {
              "key":"CC",
              "label":{
                "en":"Cocos (Keeling) Islands",
                "fr":"Îles Cocos",
                "it":"Isole Cocos (Keeling)"
              }
            },
            {
              "key":"CD",
              "label":{
                "en":"Democratic Republic of the Congo",
                "fr":"République démocratique du Congo",
                "it":"RD del Congo"
              }
            },
            {
              "key":"CF",
              "label":{
                "en":"Central African Republic",
                "fr":"République centrafricaine",
                "it":"Rep. Centrafricana"
              }
            },
            {
              "key":"CG",
              "label":{
                "en":"Congo",
                "fr":"République du Congo",
                "it":"Rep. del Congo"
              }
            },
            {
              "key":"CH",
              "label":{
                "en":"Switzerland",
                "fr":"Suisse",
                "it":"Svizzera"
              }
            },
            {
              "key":"CI",
              "label":{
                "en":"Côte d'Ivoire",
                "fr":"Côte d’Ivoire",
                "it":"Costa d'Avorio"
              }
            },
            {
              "key":"CK",
              "label":{
                "en":"Cook Islands",
                "fr":"Îles Cook",
                "it":"Isole Cook"
              }
            },
            {
              "key":"CL",
              "label":{
                "en":"Chile",
                "fr":"Chili",
                "it":"Cile"
              }
            },
            {
              "key":"CM",
              "label":{
                "en":"Cameroon",
                "fr":"Cameroun",
                "it":"Camerun"
              }
            },
            {
              "key":"CN",
              "label":{
                "en":"China",
                "fr":"Chine",
                "it":"Cina"
              }
            },
            {
              "key":"CO",
              "label":{
                "en":"Colombia",
                "fr":"Colombie",
                "it":"Colombia"
              }
            },
            {
              "key":"CR",
              "label":{
                "en":"Costa Rica",
                "fr":"Costa Rica",
                "it":"Costa Rica"
              }
            },
            {
              "key":"CU",
              "label":{
                "en":"Cuba",
                "fr":"Cuba",
                "it":"Cuba"
              }
            },
            {
              "key":"CV",
              "label":{
                "en":"Cabo Verde",
                "fr":"Cap-Vert",
                "it":"Capo Verde"
              }
            },
            {
              "key":"CW",
              "label":{
                "en":"Curaçao",
                "fr":"Curaçao",
                "it":"Curaçao"
              }
            },
            {
              "key":"CX",
              "label":{
                "en":"Christmas Island",
                "fr":"Île Christmas",
                "it":"Isola di Natale"
              }
            },
            {
              "key":"CY",
              "label":{
                "en":"Cyprus",
                "fr":"Chypre",
                "it":"Cipro"
              }
            },
            {
              "key":"CZ",
              "label":{
                "en":"Czechia",
                "fr":"République tchèque",
                "it":"Rep. Ceca"
              }
            },
            {
              "key":"DE",
              "label":{
                "en":"Germany",
                "fr":"Allemagne",
                "it":"Germania"
              }
            },
            {
              "key":"DJ",
              "label":{
                "en":"Djibouti",
                "fr":"Djibouti",
                "it":"Gibuti"
              }
            },
            {
              "key":"DK",
              "label":{
                "en":"Denmark",
                "fr":"Danemark",
                "it":"Danimarca"
              }
            },
            {
              "key":"DM",
              "label":{
                "en":"Dominica",
                "fr":"Dominique",
                "it":"Dominica"
              }
            },
            {
              "key":"DO",
              "label":{
                "en":"Dominican Republic",
                "fr":"République dominicaine",
                "it":"Rep. Dominicana"
              }
            },
            {
              "key":"DZ",
              "label":{
                "en":"Algeria",
                "fr":"Algérie",
                "it":"Algeria"
              }
            },
            {
              "key":"EC",
              "label":{
                "en":"Ecuador",
                "fr":"Équateur",
                "it":"Ecuador"
              }
            },
            {
              "key":"EE",
              "label":{
                "en":"Estonia",
                "fr":"Estonie",
                "it":"Estonia"
              }
            },
            {
              "key":"EG",
              "label":{
                "en":"Egypt",
                "fr":"Égypte",
                "it":"Egitto"
              }
            },
            {
              "key":"EH",
              "label":{
                "en":"Western Sahara",
                "fr":"Sahara occidental",
                "it":"Sahara Occidentale"
              }
            },
            {
              "key":"ER",
              "label":{
                "en":"Eritrea",
                "fr":"Érythrée",
                "it":"Eritrea"
              }
            },
            {
              "key":"ES",
              "label":{
                "en":"Spain",
                "fr":"Espagne",
                "it":"Spagna"
              }
            },
            {
              "key":"ET",
              "label":{
                "en":"Ethiopia",
                "fr":"Éthiopie",
                "it":"Etiopia"
              }
            },
            {
              "key":"FI",
              "label":{
                "en":"Finland",
                "fr":"Finlande",
                "it":"Finlandia"
              }
            },
            {
              "key":"FJ",
              "label":{
                "en":"Fiji",
                "fr":"Fidji",
                "it":"Figi"
              }
            },
            {
              "key":"FK",
              "label":{
                "en":"Falkland Islands [Malvinas]",
                "fr":"Îles Falkland",
                "it":"Isole Falkland"
              }
            },
            {
              "key":"FM",
              "label":{
                "en":"Micronesia",
                "fr":"Micronésie",
                "it":"Micronesia"
              }
            },
            {
              "key":"FO",
              "label":{
                "en":"Faroe Islands",
                "fr":"Îles Féroé",
                "it":"Fær Øer"
              }
            },
            {
              "key":"FR",
              "label":{
                "en":"France",
                "fr":"France",
                "it":"Francia"
              }
            },
            {
              "key":"GA",
              "label":{
                "en":"Gabon",
                "fr":"Gabon",
                "it":"Gabon"
              }
            },
            {
              "key":"GB",
              "label":{
                "en":"United Kingdom of Great Britain and Northern Ireland",
                "fr":"Royaume-Uni",
                "it":"Regno Unito"
              }
            },
            {
              "key":"GD",
              "label":{
                "en":"Grenada",
                "fr":"Grenade",
                "it":"Grenada"
              }
            },
            {
              "key":"GE",
              "label":{
                "en":"Georgia",
                "fr":"Géorgie",
                "it":"Georgia"
              }
            },
            {
              "key":"GF",
              "label":{
                "en":"French Guiana",
                "fr":"Guyane française",
                "it":"Guyana francese"
              }
            },
            {
              "key":"GG",
              "label":{
                "en":"Guernsey",
                "fr":"Guernesey",
                "it":"Guernsey"
              }
            },
            {
              "key":"GH",
              "label":{
                "en":"Ghana",
                "fr":"Ghana",
                "it":"Ghana"
              }
            },
            {
              "key":"GI",
              "label":{
                "en":"Gibraltar",
                "fr":"Gibraltar",
                "it":"Gibilterra"
              }
            },
            {
              "key":"GL",
              "label":{
                "en":"Greenland",
                "fr":"Groenland",
                "it":"Groenlandia"
              }
            },
            {
              "key":"GM",
              "label":{
                "en":"Gambia",
                "fr":"Gambie",
                "it":"Gambia"
              }
            },
            {
              "key":"GN",
              "label":{
                "en":"Guinea",
                "fr":"Guinée",
                "it":"Guinea"
              }
            },
            {
              "key":"GP",
              "label":{
                "en":"Guadeloupe",
                "fr":"Guadeloupe",
                "it":"Guadalupa"
              }
            },
            {
              "key":"GQ",
              "label":{
                "en":"Equatorial Guinea",
                "fr":"Guinée équatoriale",
                "it":"Guinea Equatoriale"
              }
            },
            {
              "key":"GR",
              "label":{
                "en":"Greece",
                "fr":"Grèce",
                "it":"Grecia"
              }
            },
            {
              "key":"GS",
              "label":{
                "en":"South Georgia and the South Sandwich Islands",
                "fr":"Géorgie du Sud et les îles Sandwich du Sud",
                "it":"Georgia del Sud e Isole Sandwich Australi"
              }
            },
            {
              "key":"GT",
              "label":{
                "en":"Guatemala",
                "fr":"Guatemala",
                "it":"Guatemala"
              }
            },
            {
              "key":"GU",
              "label":{
                "en":"Guam",
                "fr":"Guam",
                "it":"Guam"
              }
            },
            {
              "key":"GW",
              "label":{
                "en":"Guinea-Bissau",
                "fr":"Guinée-Bissau",
                "it":"Guinea-Bissau"
              }
            },
            {
              "key":"GY",
              "label":{
                "en":"Guyana",
                "fr":"Guyane",
                "it":"Guyana"
              }
            },
            {
              "key":"HK",
              "label":{
                "en":"Hong Kong",
                "fr":"Hong Kong",
                "it":"Hong Kong"
              }
            },
            {
              "key":"HM",
              "label":{
                "en":"Heard Island and McDonald Islands",
                "fr":"Îles Heard-et-MacDonald",
                "it":"Isole Heard e McDonald"
              }
            },
            {
              "key":"HN",
              "label":{
                "en":"Honduras",
                "fr":"Honduras",
                "it":"Honduras"
              }
            },
            {
              "key":"HR",
              "label":{
                "en":"Croatia",
                "fr":"Croatie",
                "it":"Croazia"
              }
            },
            {
              "key":"HT",
              "label":{
                "en":"Haiti",
                "fr":"Haïti",
                "it":"Haiti"
              }
            },
            {
              "key":"HU",
              "label":{
                "en":"Hungary",
                "fr":"Hongrie",
                "it":"Ungheria"
              }
            },
            {
              "key":"ID",
              "label":{
                "en":"Indonesia",
                "fr":"Indonésie",
                "it":"Indonesia"
              }
            },
            {
              "key":"IE",
              "label":{
                "en":"Ireland",
                "fr":"Irlande",
                "it":"Irlanda"
              }
            },
            {
              "key":"IL",
              "label":{
                "en":"Israel",
                "fr":"Israël",
                "it":"Israele"
              }
            },
            {
              "key":"IM",
              "label":{
                "en":"Isle of Man",
                "fr":"Ile de Man",
                "it":"Isola di Man"
              }
            },
            {
              "key":"IN",
              "label":{
                "en":"India",
                "fr":"Inde",
                "it":"India"
              }
            },
            {
              "key":"IO",
              "label":{
                "en":"British Indian Ocean Territory",
                "fr":"Territoire britannique de l’Océan Indien",
                "it":"Territorio britannico dell'Oceano Indiano"
              }
            },
            {
              "key":"IQ",
              "label":{
                "en":"Iraq",
                "fr":"Irak",
                "it":"Iraq"
              }
            },
            {
              "key":"IR",
              "label":{
                "en":"Iran",
                "fr":"Iran",
                "it":"Iran"
              }
            },
            {
              "key":"IS",
              "label":{
                "en":"Iceland",
                "fr":"Islande",
                "it":"Islanda"
              }
            },
            {
              "key":"IT",
              "label":{
                "en":"Italy",
                "fr":"Italie",
                "it":"Italia"
              }
            },
            {
              "key":"JE",
              "label":{
                "en":"Jersey",
                "fr":"Jersey",
                "it":"Jersey"
              }
            },
            {
              "key":"JM",
              "label":{
                "en":"Jamaica",
                "fr":"Jamaïque",
                "it":"Giamaica"
              }
            },
            {
              "key":"JO",
              "label":{
                "en":"Jordan",
                "fr":"Jordanie",
                "it":"Giordania"
              }
            },
            {
              "key":"JP",
              "label":{
                "en":"Japan",
                "fr":"Japon",
                "it":"Giappone"
              }
            },
            {
              "key":"KE",
              "label":{
                "en":"Kenya",
                "fr":"Kenya",
                "it":"Kenya"
              }
            },
            {
              "key":"KG",
              "label":{
                "en":"Kyrgyzstan",
                "fr":"Kirghizistan",
                "it":"Kirghizistan"
              }
            },
            {
              "key":"KH",
              "label":{
                "en":"Cambodia",
                "fr":"Cambodge",
                "it":"Cambogia"
              }
            },
            {
              "key":"KI",
              "label":{
                "en":"Kiribati",
                "fr":"Kiribati",
                "it":"Kiribati"
              }
            },
            {
              "key":"KM",
              "label":{
                "en":"Comoros",
                "fr":"Comores",
                "it":"Comore"
              }
            },
            {
              "key":"KN",
              "label":{
                "en":"Saint Kitts and Nevis",
                "fr":"Saint-Kitts-et-Nevis",
                "it":"Saint Kitts e Nevis"
              }
            },
            {
              "key":"KP",
              "label":{
                "en":"Korea (the Democratic People's Republic of)",
                "fr":"Corée du Nord",
                "it":"Corea del Nord"
              }
            },
            {
              "key":"KR",
              "label":{
                "en":"Republic of Korea",
                "fr":"Corée du Sud",
                "it":"Corea del Sud"
              }
            },
            {
              "key":"KW",
              "label":{
                "en":"Kuwait",
                "fr":"Koweït",
                "it":"Kuwait"
              }
            },
            {
              "key":"KY",
              "label":{
                "en":"Cayman Islands",
                "fr":"Iles Cayman",
                "it":"Isole Cayman"
              }
            },
            {
              "key":"KZ",
              "label":{
                "en":"Kazakhstan",
                "fr":"Kazakhstan",
                "it":"Kazakistan"
              }
            },
            {
              "key":"LA",
              "label":{
                "en":"Lao People's Democratic Republic",
                "fr":"Laos",
                "it":"Laos"
              }
            },
            {
              "key":"LB",
              "label":{
                "en":"Lebanon",
                "fr":"Liban",
                "it":"Libano"
              }
            },
            {
              "key":"LC",
              "label":{
                "en":"Saint Lucia",
                "fr":"Sainte-Lucie",
                "it":"Saint Lucia"
              }
            },
            {
              "key":"LI",
              "label":{
                "en":"Liechtenstein",
                "fr":"Liechtenstein",
                "it":"Liechtenstein"
              }
            },
            {
              "key":"LK",
              "label":{
                "en":"Sri Lanka",
                "fr":"Sri Lanka",
                "it":"Sri Lanka"
              }
            },
            {
              "key":"LR",
              "label":{
                "en":"Liberia",
                "fr":"Libéria",
                "it":"Liberia"
              }
            },
            {
              "key":"LS",
              "label":{
                "en":"Lesotho",
                "fr":"Lesotho",
                "it":"Lesotho"
              }
            },
            {
              "key":"LT",
              "label":{
                "en":"Lithuania",
                "fr":"Lituanie",
                "it":"Lituania"
              }
            },
            {
              "key":"LU",
              "label":{
                "en":"Luxembourg",
                "fr":"Luxembourg",
                "it":"Lussemburgo"
              }
            },
            {
              "key":"LV",
              "label":{
                "en":"Latvia",
                "fr":"Lettonie",
                "it":"Lettonia"
              }
            },
            {
              "key":"LY",
              "label":{
                "en":"Libya",
                "fr":"Libye",
                "it":"Libia"
              }
            },
            {
              "key":"MA",
              "label":{
                "en":"Morocco",
                "fr":"Maroc",
                "it":"Marocco"
              }
            },
            {
              "key":"MC",
              "label":{
                "en":"Monaco",
                "fr":"Monaco",
                "it":"Monaco"
              }
            },
            {
              "key":"MD",
              "label":{
                "en":"Moldova",
                "fr":"Moldavie",
                "it":"Moldavia"
              }
            },
            {
              "key":"ME",
              "label":{
                "en":"Montenegro",
                "fr":"Monténégro",
                "it":"Montenegro"
              }
            },
            {
              "key":"MF",
              "label":{
                "en":"Saint Martin (French part)",
                "fr":"Saint-Martin (partie française)",
                "it":"Saint-Martin"
              }
            },
            {
              "key":"MG",
              "label":{
                "en":"Madagascar",
                "fr":"Madagascar",
                "it":"Madagascar"
              }
            },
            {
              "key":"MH",
              "label":{
                "en":"Marshall Islands",
                "fr":"Îles Marshall",
                "it":"Isole Marshall"
              }
            },
            {
              "key":"MK",
              "label":{
                "en":"Republic of North Macedonia",
                "fr":"Macédoine",
                "it":"Macedonia del Nord"
              }
            },
            {
              "key":"ML",
              "label":{
                "en":"Mali",
                "fr":"Mali",
                "it":"Mali"
              }
            },
            {
              "key":"MM",
              "label":{
                "en":"Myanmar",
                "fr":"Myanmar",
                "it":"Birmania"
              }
            },
            {
              "key":"MN",
              "label":{
                "en":"Mongolia",
                "fr":"Mongolie",
                "it":"Mongolia"
              }
            },
            {
              "key":"MO",
              "label":{
                "en":"Macao",
                "fr":"Macao",
                "it":"Macao"
              }
            },
            {
              "key":"MP",
              "label":{
                "en":"Northern Mariana Islands",
                "fr":"Îles Mariannes du Nord",
                "it":"Isole Marianne Settentrionali"
              }
            },
            {
              "key":"MQ",
              "label":{
                "en":"Martinique",
                "fr":"Martinique",
                "it":"Martinica"
              }
            },
            {
              "key":"MR",
              "label":{
                "en":"Mauritania",
                "fr":"Mauritanie",
                "it":"Mauritania"
              }
            },
            {
              "key":"MS",
              "label":{
                "en":"Montserrat",
                "fr":"Montserrat",
                "it":"Montserrat"
              }
            },
            {
              "key":"MT",
              "label":{
                "en":"Malta",
                "fr":"Malte",
                "it":"Malta"
              }
            },
            {
              "key":"MU",
              "label":{
                "en":"Mauritius",
                "fr":"Maurice",
                "it":"Mauritius"
              }
            },
            {
              "key":"MV",
              "label":{
                "en":"Maldives",
                "fr":"Maldives",
                "it":"Maldive"
              }
            },
            {
              "key":"MW",
              "label":{
                "en":"Malawi",
                "fr":"Malawi",
                "it":"Malawi"
              }
            },
            {
              "key":"MX",
              "label":{
                "en":"Mexico",
                "fr":"Mexique",
                "it":"Messico"
              }
            },
            {
              "key":"MY",
              "label":{
                "en":"Malaysia",
                "fr":"Malaisie",
                "it":"Malaysia"
              }
            },
            {
              "key":"MZ",
              "label":{
                "en":"Mozambique",
                "fr":"Mozambique",
                "it":"Mozambico"
              }
            },
            {
              "key":"NA",
              "label":{
                "en":"Namibia",
                "fr":"Namibie",
                "it":"Namibia"
              }
            },
            {
              "key":"NC",
              "label":{
                "en":"New Caledonia",
                "fr":"Nouvelle-Calédonie",
                "it":"Nuova Caledonia"
              }
            },
            {
              "key":"NE",
              "label":{
                "en":"Niger",
                "fr":"Niger",
                "it":"Niger"
              }
            },
            {
              "key":"NF",
              "label":{
                "en":"Norfolk Island",
                "fr":"Île Norfolk",
                "it":"Isola Norfolk"
              }
            },
            {
              "key":"NG",
              "label":{
                "en":"Nigeria",
                "fr":"Nigeria",
                "it":"Nigeria"
              }
            },
            {
              "key":"NI",
              "label":{
                "en":"Nicaragua",
                "fr":"Nicaragua",
                "it":"Nicaragua"
              }
            },
            {
              "key":"NL",
              "label":{
                "en":"Netherlands",
                "fr":"Pays-Bas",
                "it":"Paesi Bassi"
              }
            },
            {
              "key":"NO",
              "label":{
                "en":"Norway",
                "fr":"Norvège",
                "it":"Norvegia"
              }
            },
            {
              "key":"NP",
              "label":{
                "en":"Nepal",
                "fr":"Népal",
                "it":"Nepal"
              }
            },
            {
              "key":"NR",
              "label":{
                "en":"Nauru",
                "fr":"Nauru",
                "it":"Nauru"
              }
            },
            {
              "key":"NU",
              "label":{
                "en":"Niue",
                "fr":"Niue",
                "it":"Niue"
              }
            },
            {
              "key":"NZ",
              "label":{
                "en":"New Zealand",
                "fr":"Nouvelle-Zélande",
                "it":"Nuova Zelanda"
              }
            },
            {
              "key":"OM",
              "label":{
                "en":"Oman",
                "fr":"Oman",
                "it":"Oman"
              }
            },
            {
              "key":"PA",
              "label":{
                "en":"Panama",
                "fr":"Panama",
                "it":"Panama"
              }
            },
            {
              "key":"PE",
              "label":{
                "en":"Peru",
                "fr":"Pérou",
                "it":"Perù"
              }
            },
            {
              "key":"PF",
              "label":{
                "en":"French Polynesia",
                "fr":"Polynésie française",
                "it":"Polinesia francese"
              }
            },
            {
              "key":"PG",
              "label":{
                "en":"Papua New Guinea",
                "fr":"Papouasie-Nouvelle-Guinée",
                "it":"Papua Nuova Guinea"
              }
            },
            {
              "key":"PH",
              "label":{
                "en":"Philippines",
                "fr":"Philippines",
                "it":"Filippine"
              }
            },
            {
              "key":"PK",
              "label":{
                "en":"Pakistan",
                "fr":"Pakistan",
                "it":"Pakistan"
              }
            },
            {
              "key":"PL",
              "label":{
                "en":"Poland",
                "fr":"Pologne",
                "it":"Polonia"
              }
            },
            {
              "key":"PM",
              "label":{
                "en":"Saint Pierre and Miquelon",
                "fr":"Saint-Pierre-et-Miquelon",
                "it":"Saint-Pierre e Miquelon"
              }
            },
            {
              "key":"PN",
              "label":{
                "en":"Pitcairn",
                "fr":"Pitcairn",
                "it":"Isole Pitcairn"
              }
            },
            {
              "key":"PR",
              "label":{
                "en":"Puerto Rico",
                "fr":"Puerto Rico",
                "it":"Porto Rico"
              }
            },
            {
              "key":"PS",
              "label":{
                "en":"Palestine",
                "fr":"Palestine",
                "it":"Palestina"
              }
            },
            {
              "key":"PT",
              "label":{
                "en":"Portugal",
                "fr":"Portugal",
                "it":"Portogallo"
              }
            },
            {
              "key":"PW",
              "label":{
                "en":"Palau",
                "fr":"Palau",
                "it":"Palau"
              }
            },
            {
              "key":"PY",
              "label":{
                "en":"Paraguay",
                "fr":"Paraguay",
                "it":"Paraguay"
              }
            },
            {
              "key":"QA",
              "label":{
                "en":"Qatar",
                "fr":"Qatar",
                "it":"Qatar"
              }
            },
            {
              "key":"RE",
              "label":{
                "en":"Réunion",
                "fr":"Réunion",
                "it":"Riunione"
              }
            },
            {
              "key":"RO",
              "label":{
                "en":"Romania",
                "fr":"Roumanie",
                "it":"Romania"
              }
            },
            {
              "key":"RS",
              "label":{
                "en":"Serbia",
                "fr":"Serbie",
                "it":"Serbia"
              }
            },
            {
              "key":"RU",
              "label":{
                "en":"Russian Federation",
                "fr":"Russie",
                "it":"Russia"
              }
            },
            {
              "key":"RW",
              "label":{
                "en":"Rwanda",
                "fr":"Rwanda",
                "it":"Ruanda"
              }
            },
            {
              "key":"SA",
              "label":{
                "en":"Saudi Arabia",
                "fr":"Arabie Saoudite",
                "it":"Arabia Saudita"
              }
            },
            {
              "key":"SB",
              "label":{
                "en":"Solomon Islands",
                "fr":"Îles Salomon",
                "it":"Isole Salomone"
              }
            },
            {
              "key":"SC",
              "label":{
                "en":"Seychelles",
                "fr":"Seychelles",
                "it":"Seychelles"
              }
            },
            {
              "key":"SD",
              "label":{
                "en":"Sudan",
                "fr":"Soudan",
                "it":"Sudan"
              }
            },
            {
              "key":"SE",
              "label":{
                "en":"Sweden",
                "fr":"Suède",
                "it":"Svezia"
              }
            },
            {
              "key":"SG",
              "label":{
                "en":"Singapore",
                "fr":"Singapour",
                "it":"Singapore"
              }
            },
            {
              "key":"SH",
              "label":{
                "en":"Saint Helena, Ascension and Tristan da Cunha",
                "fr":"Sainte-Hélène",
                "it":"Sant'Elena, Ascensione e Tristan da Cunha"
              }
            },
            {
              "key":"SI",
              "label":{
                "en":"Slovenia",
                "fr":"Slovénie",
                "it":"Slovenia"
              }
            },
            {
              "key":"SJ",
              "label":{
                "en":"Svalbard and Jan Mayen",
                "fr":"Svalbard et Jan Mayen",
                "it":"Svalbard e Jan Mayen"
              }
            },
            {
              "key":"SK",
              "label":{
                "en":"Slovakia",
                "fr":"Slovaquie",
                "it":"Slovacchia"
              }
            },
            {
              "key":"SL",
              "label":{
                "en":"Sierra Leone",
                "fr":"Sierra Leone",
                "it":"Sierra Leone"
              }
            },
            {
              "key":"SM",
              "label":{
                "en":"San Marino",
                "fr":"Saint-Marin",
                "it":"San Marino"
              }
            },
            {
              "key":"SN",
              "label":{
                "en":"Senegal",
                "fr":"Sénégal",
                "it":"Senegal"
              }
            },
            {
              "key":"SO",
              "label":{
                "en":"Somalia",
                "fr":"Somalie",
                "it":"Somalia"
              }
            },
            {
              "key":"SS",
              "label":{
                "en":"South Sudan",
                "fr":"Soudan du sud",
                "it":"Sudan del Sud"
              }
            },
            {
              "key":"SR",
              "label":{
                "en":"Suriname",
                "fr":"Suriname",
                "it":"Suriname"
              }
            },
            {
              "key":"ST",
              "label":{
                "en":"Sao Tome and Principe",
                "fr":"Sao Tomé-et-Principe",
                "it":"São Tomé e Príncipe"
              }
            },
            {
              "key":"SV",
              "label":{
                "en":"El Salvador",
                "fr":"Salvador",
                "it":"El Salvador"
              }
            },
            {
              "key":"SX",
              "label":{
                "en":"Sint Maarten (Dutch part)",
                "fr":"Saint-Martin (partie néerlandaise)",
                "it":"Sint Maarten"
              }
            },
            {
              "key":"SY",
              "label":{
                "en":"Syria",
                "fr":"Syrie",
                "it":"Siria"
              }
            },
            {
              "key":"SZ",
              "label":{
                "en":"Eswatini",
                "fr":"Eswatini",
                "it":"eSwatini"
              }
            },
            {
              "key":"TC",
              "label":{
                "en":"Turks and Caicos Islands (the)",
                "fr":"Îles Turques-et-Caïques",
                "it":"Turks e Caicos"
              }
            },
            {
              "key":"TD",
              "label":{
                "en":"Chad",
                "fr":"Tchad",
                "it":"Ciad"
              }
            },
            {
              "key":"TF",
              "label":{
                "en":"French Southern Territories",
                "fr":"Terres australes et antarctiques françaises",
                "it":"Terre australi e antartiche francesi"
              }
            },
            {
              "key":"TG",
              "label":{
                "en":"Togo",
                "fr":"Togo",
                "it":"Togo"
              }
            },
            {
              "key":"TH",
              "label":{
                "en":"Thailand",
                "fr":"Thaïlande",
                "it":"Thailandia"
              }
            },
            {
              "key":"TJ",
              "label":{
                "en":"Tajikistan",
                "fr":"Tadjikistan",
                "it":"Tagikistan"
              }
            },
            {
              "key":"TK",
              "label":{
                "en":"Tokelau",
                "fr":"Tokelau",
                "it":"Tokelau"
              }
            },
            {
              "key":"TL",
              "label":{
                "en":"Timor-Leste",
                "fr":"Timor-Leste",
                "it":"Timor Est"
              }
            },
            {
              "key":"TM",
              "label":{
                "en":"Turkmenistan",
                "fr":"Turkménistan",
                "it":"Turkmenistan"
              }
            },
            {
              "key":"TN",
              "label":{
                "en":"Tunisia",
                "fr":"Tunisie",
                "it":"Tunisia"
              }
            },
            {
              "key":"TO",
              "label":{
                "en":"Tonga",
                "fr":"Tonga",
                "it":"Tonga"
              }
            },
            {
              "key":"TR",
              "label":{
                "en":"Turkey",
                "fr":"Turquie",
                "it":"Turchia"
              }
            },
            {
              "key":"TT",
              "label":{
                "en":"Trinidad and Tobago",
                "fr":"Trinité-et-Tobago",
                "it":"Trinidad e Tobago"
              }
            },
            {
              "key":"TV",
              "label":{
                "en":"Tuvalu",
                "fr":"Tuvalu",
                "it":"Tuvalu"
              }
            },
            {
              "key":"TW",
              "label":{
                "en":"Taiwan",
                "fr":"Taiwan",
                "it":"Taiwan"
              }
            },
            {
              "key":"TZ",
              "label":{
                "en":"Tanzania",
                "fr":"Tanzanie",
                "it":"Tanzania"
              }
            },
            {
              "key":"UA",
              "label":{
                "en":"Ukraine",
                "fr":"Ukraine",
                "it":"Ucraina"
              }
            },
            {
              "key":"UG",
              "label":{
                "en":"Uganda",
                "fr":"Ouganda",
                "it":"Uganda"
              }
            },
            {
              "key":"UM",
              "label":{
                "en":"United States Minor Outlying Islands",
                "fr":"Îles mineures éloignées des États-Unis",
                "it":"Isole minori esterne degli Stati Uniti"
              }
            },
            {
              "key":"US",
              "label":{
                "en":"United States of America",
                "fr":"États-Unis",
                "it":"Stati Uniti"
              }
            },
            {
              "key":"UY",
              "label":{
                "en":"Uruguay",
                "fr":"Uruguay",
                "it":"Uruguay"
              }
            },
            {
              "key":"UZ",
              "label":{
                "en":"Uzbekistan",
                "fr":"Ouzbékistan",
                "it":"Uzbekistan"
              }
            },
            {
              "key":"VA",
              "label":{
                "en":"Holy See",
                "fr":"Saint-Siège (Vatican)",
                "it":"Città del Vaticano"
              }
            },
            {
              "key":"VC",
              "label":{
                "en":"Saint Vincent and the Grenadines",
                "fr":"Saint-Vincent-et-les Grenadines",
                "it":"Saint Vincent e Grenadine"
              }
            },
            {
              "key":"VE",
              "label":{
                "en":"Venezuela",
                "fr":"Venezuela",
                "it":"Venezuela"
              }
            },
            {
              "key":"VG",
              "label":{
                "en":"Virgin Islands (British)",
                "fr":"British Virgin Islands",
                "it":"Isole Vergini britanniche"
              }
            },
            {
              "key":"VI",
              "label":{
                "en":"Virgin Islands (U.S.)",
                "fr":"Îles Vierges américaines",
                "it":"Isole Vergini americane"
              }
            },
            {
              "key":"VN",
              "label":{
                "en":"Viet Nam",
                "fr":"Viêt Nam",
                "it":"Vietnam"
              }
            },
            {
              "key":"VU",
              "label":{
                "en":"Vanuatu",
                "fr":"Vanuatu",
                "it":"Vanuatu"
              }
            },
            {
              "key":"WF",
              "label":{
                "en":"Wallis and Futuna",
                "fr":"Wallis-et-Futuna",
                "it":"Wallis e Futuna"
              }
            },
            {
              "key":"WS",
              "label":{
                "en":"Samoa",
                "fr":"Samoa",
                "it":"Samoa"
              }
            },
            {
              "key":"YE",
              "label":{
                "en":"Yemen",
                "fr":"Yémen",
                "it":"Yemen"
              }
            },
            {
              "key":"YT",
              "label":{
                "en":"Mayotte",
                "fr":"Mayotte",
                "it":"Mayotte"
              }
            },
            {
              "key":"ZA",
              "label":{
                "en":"South Africa",
                "fr":"Afrique du Sud",
                "it":"Sudafrica"
              }
            },
            {
              "key":"ZM",
              "label":{
                "en":"Zambia",
                "fr":"Zambie",
                "it":"Zambia"
              }
            },
            {
              "key":"ZW",
              "label":{
                "en":"Zimbabwe",
                "fr":"Zimbabwe",
                "it":"Zimbabwe"
              }
            }
          ]
        }
      },
      "attributeConstraint":"SameForAll",
      "isSearchable":true,
      "inputHint":"SingleLine",
      "displayGroup":"Other"
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

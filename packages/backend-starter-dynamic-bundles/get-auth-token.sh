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

echo $response
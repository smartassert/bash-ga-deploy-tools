#!/usr/bin/env bash

AUTH_HEADER="Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}"
URL="https://api.digitalocean.com/v2/snapshots/${IMAGE_ID}"

curl -s -X DELETE -H 'Content-Type: application/json' -H "${AUTH_HEADER}" "${URL}"

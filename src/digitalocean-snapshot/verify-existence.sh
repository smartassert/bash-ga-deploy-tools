#!/usr/bin/env bash

EXIT_CODE_INVALID_API_RESPONSE=3

if [ -z "$EXPECTED_EXISTS" ] || { [ "$EXPECTED_EXISTS" != "true" ] && [ "$EXPECTED_EXISTS" != "false" ]; }; then
  EXPECTED_EXISTS="true"
fi

AUTH_HEADER="Authorization: Bearer ${DIGITALOCEAN_API_TOKEN}"
URL="https://api.digitalocean.com/v2/snapshots/${IMAGE_ID}"

RESPONSE_BODY=$(curl -s -X GET -H 'Content-Type: application/json' -H "${AUTH_HEADER}" "${URL}")
RESPONSE_BODY_HAS_SNAPSHOT=$(echo "$RESPONSE_BODY" | jq 'has("snapshot")' 2>/dev/null)
JQ_EXIT_CODE="$?"

if [ "0" != "$JQ_EXIT_CODE" ]; then
  echo "Invalid API response:"
  echo "$RESPONSE_BODY"
  echo "jq exit code: $JQ_EXIT_CODE"
  exit "$EXIT_CODE_INVALID_API_RESPONSE"
fi

exit "$([ "$RESPONSE_BODY_HAS_SNAPSHOT" = "$EXPECTED_EXISTS" ] && echo 0 || echo 1)"

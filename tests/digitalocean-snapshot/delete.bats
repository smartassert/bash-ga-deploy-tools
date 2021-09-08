#!/usr/bin/env bats

project_dir="${BATS_TEST_DIRNAME%tests*}"
project_dir="${project_dir%/}"

test_path="${BATS_TEST_FILENAME##*tests}"
script_path="${test_path/bats/sh}"

setup() {
  load "$project_dir/tests/node_modules/bats-support/load.bash"
  load "$project_dir/tests/node_modules/bats-assert/load.bash"

  export DIGITALOCEAN_API_TOKEN="token"
  export IMAGE_ID="12345"

  function curl() {
    echo "$1 $2 $3 $4 $5 $6 $7 $8"
  }

  export -f curl
}

main() {
  bash "$project_dir/src/$script_path"
}

@test "$script_path: request is formed correctly" {
  run main

  assert_success
  assert_output "-s -X DELETE -H Content-Type: application/json -H Authorization: Bearer $DIGITALOCEAN_API_TOKEN https://api.digitalocean.com/v2/snapshots/$IMAGE_ID"
}

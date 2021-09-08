#!/usr/bin/env bats

project_dir="${BATS_TEST_DIRNAME%tests*}"
project_dir="${project_dir%/}"

test_path="${BATS_TEST_FILENAME##*tests}"
script_path="${test_path/bats/sh}"

setup() {
  load "$project_dir/tests/node_modules/bats-support/load.bash"
  load "$project_dir/tests/node_modules/bats-assert/load.bash"
}

main() {
  bash "$project_dir/src/$script_path"
}

@test "$script_path: fails with no arguments" {
  run main

  assert_failure "1"
}

@test "$script_path: fails with invalid EVENT_NAME" {
  EVENT_NAME=FOO \
  run main

  assert_failure "2"
}

@test "$script_path: fails with EVENT_NAME=pull_request and empty PR_NUMBER" {
  EVENT_NAME=pull_request \
  run main

  assert_failure "3"
}

@test "$script_path: fails with EVENT_NAME=release and empty VERSION" {
  EVENT_NAME=release \
  run main

    assert_failure "4"
}

@test "$script_path: fails with EVENT_NAME=workflow_dispatch and empty VERSION" {
  EVENT_NAME=workflow_dispatch \
  run main

    assert_failure "4"
}

@test "$script_path: succeeds with EVENT_NAME=push" {
  EVENT_NAME=push \
  run main

  assert_success
  assert_output "master"
}

@test "$script_path: succeeds with EVENT_NAME=pull_request, PR_NUMBER=101" {
  EVENT_NAME=pull_request \
  PR_NUMBER="101" \
  run main

  assert_success
  assert_output "pull-request-101"
}

@test "$script_path: succeeds with EVENT_NAME=release, VERSION=0.1" {
  EVENT_NAME=release \
  VERSION=0.1 \
  run main

  assert_success
  assert_output "release-0.1"
}

@test "$script_path: succeeds with EVENT_NAME=release, VERSION='0.2'" {
  EVENT_NAME=release \
  VERSION='0.2' \
  run main

  assert_success
  assert_output "release-0.2"
}

@test "$script_path: succeeds with EVENT_NAME=workflow_dispatch, VERSION=0.3" {
  EVENT_NAME=workflow_dispatch \
  VERSION=0.3 \
  run main

  assert_success
  assert_output "release-0.3"
}

@test "$script_path: succeeds with EVENT_NAME=workflow_dispatch, VERSION='0.4'" {
  EVENT_NAME=workflow_dispatch \
  VERSION='0.4' \
  run main

  assert_success
  assert_output "release-0.4"
}

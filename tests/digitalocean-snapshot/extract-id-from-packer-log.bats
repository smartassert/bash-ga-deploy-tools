#!/usr/bin/env bats

project_dir="${BATS_TEST_DIRNAME%tests*}"
project_dir="${project_dir%/}"

test_path="${BATS_TEST_FILENAME##*tests}"
script_path="${test_path/bats/sh}"

setup() {
  load "$project_dir/tests/node_modules/bats-support/load.bash"
  load "$project_dir/tests/node_modules/bats-assert/load.bash"
  load "$project_dir/tests/node_modules/bats-file/load.bash"

  export PACKER_LOG_PATH="$BATS_TMPDIR/packer.log"

  teardown
}

teardown() {
  rm -f "$PACKER_LOG_PATH"
}

main() {
  bash "$project_dir/src/$script_path"
}

@test "$script_path: packer log path not set" {
  unset PACKER_LOG_PATH
  run main

  assert_failure "3"
  assert_output ""
}

@test "$script_path: packer log path not found" {
  run main

  assert_failure "4"
  assert_output ""
}

@test "$script_path: no line containing 'Snapshot image ID' present" {
  echo "non-empty content" > "$PACKER_LOG_PATH"

  run main

  assert_failure "1"
  assert_output ""
}

@test "$script_path: success" {
  echo "2021/09/08 08:46:05 ui: digitalocean.worker_base: output will be in this color.
2021/09/08 08:48:21 Starting build run: digitalocean.worker_base
...
2021/09/08 08:52:49 packer-builder-digitalocean plugin: Snapshot image ID: 91393692
...
" > "$PACKER_LOG_PATH"

  run main

  assert_success
  assert_output "91393692"
}

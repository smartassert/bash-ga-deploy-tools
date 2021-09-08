#!/usr/bin/env bash

# push to master
# EVENT_NAME='push' ./create-snapshot-name.sh

# create pull request
# EVENT_NAME='pull_request' PR_NUMBER=101 ./create-snapshot-name.sh

# publish release
# EVENT_NAME='release' VERSION='0.1' ./create-snapshot-name.sh

# workflow_dispatch
# EVENT_NAME='workflow_dispatch' VERSION='0.4.12' ./create-snapshot-name.sh

if [ -z "$EVENT_NAME" ]; then
  exit 1
fi

if [ "push" != "$EVENT_NAME" ] &&
   [ "pull_request" != "$EVENT_NAME" ] &&
   [ "release" != "$EVENT_NAME" ] &&
   [ "workflow_dispatch" != "$EVENT_NAME" ]
then
  exit 2
fi

if [ "push" = "$EVENT_NAME" ]; then
  echo "master"
fi

if [ "pull_request" = "$EVENT_NAME" ]; then
  if [ -z "$PR_NUMBER" ]; then
    exit 3
  fi

  echo "pull-request-$PR_NUMBER"
fi

if [ "release" = "$EVENT_NAME" ] || [ "workflow_dispatch" = "$EVENT_NAME" ]; then
  if [ -z "$VERSION" ]; then
    exit 4
  fi

  echo "release-$(echo "$VERSION" | tr -d '"')"
fi

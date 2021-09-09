#!/usr/bin/env bash

EXIT_CODE_LOG_PATH_NOT_SET=3
EXIT_CODE_LOG_PATH_NOT_FOUND=4

if [ -z "$PACKER_LOG_PATH" ]; then
    exit "$EXIT_CODE_LOG_PATH_NOT_SET"
fi

if [ ! -f "$PACKER_LOG_PATH" ]; then
    exit "$EXIT_CODE_LOG_PATH_NOT_FOUND"
fi

SNAPSHOT_ID_PATTERN="[[:digit:]]+"
SNAPSHOT_ID_LINE_PATTERN="Snapshot image ID: $SNAPSHOT_ID_PATTERN"

grep --extended-regexp "$SNAPSHOT_ID_LINE_PATTERN" "$PACKER_LOG_PATH" | \
grep --extended-regexp --only-matching "$SNAPSHOT_ID_PATTERN$"

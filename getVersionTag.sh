#! /usr/bin/env bash

SHORT_SHA=$(git rev-parse --short HEAD)
TIMESTAMP=$(date "+%Y-%m-%d")
TEMP_BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"
if [ "${TEMP_BRANCH_NAME}" == "HEAD" ]; then
    TEMP_BRANCH_NAME="${BRANCH_NAME}"
fi
BRANCH_NAME=$(echo $TEMP_BRANCH_NAME | sed s/\\//-/)

printf "%s-%s-%s\n" "${BRANCH_NAME}" "${TIMESTAMP}" "${SHORT_SHA}"

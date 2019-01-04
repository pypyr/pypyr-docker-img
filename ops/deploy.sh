#!/usr/bin/env bash
# tags git code in format:
# name-0.1,0.1.1,latest
# docker hub will use everything after the dash for the tags to apply to the img
# Usage
# From repo:
# ./ops/deploy.sh [deployprefix]
# where deployprefix is the name of one of the image subdirs, e.g pypyr or
# pypyr-go or pypyr-go-terraform

# stop processing on any statement return != 0
set -eu

DEPLOYPREFIX=${1}
REPO=pypyr
echo "deploying: ${REPO}/${DEPLOYPREFIX}"
read -rsp $'Press enter to continue...\n'

# read the tags file from the image subdir
TAGS=$(< ${DEPLOYPREFIX}/tags)
TAGS_PLUS_LATEST="latest,${TAGS}"

echo the tags to apply to this image will be: ${TAGS_PLUS_LATEST}
read -rsp $'Press enter to continue...\n'

# ${TAGS} will look like this: 0.8.0
# ${TAGS_PLUS_LATEST} will look like this: latest,0.8.0
# assuming no spaces
echo will be building:
echo docker build -t ${REPO}/${DEPLOYPREFIX}:${TAGS_PLUS_LATEST//,/ -t ${REPO}/${DEPLOYPREFIX}:} -f ${DEPLOYPREFIX}/Dockerfile .
read -rsp $'Press enter to continue...\n'

# build
docker build -t ${REPO}/${DEPLOYPREFIX}:${TAGS_PLUS_LATEST//,/ -t ${REPO}/${DEPLOYPREFIX}:} -f ${DEPLOYPREFIX}/Dockerfile .

echo "build done for ${REPO}/${DEPLOYPREFIX}"
echo "running tests"
# test
. ${DEPLOYPREFIX}/hooks/test
echo "tests exit code: $?"
echo "tests done"

# git tag is pypyr-latest,0.1,0.1.1
TAG_NAME="${DEPLOYPREFIX}-${TAGS}"

echo about to push to docker repos: ${TAG_NAME}
read -rsp $'Press enter to continue...\n'

docker push ${REPO}/${DEPLOYPREFIX}:latest
docker push ${REPO}/${DEPLOYPREFIX}:${TAGS}

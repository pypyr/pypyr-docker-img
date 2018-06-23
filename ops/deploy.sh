#!/usr/bin/env bash
# tags git code in format:
# name-0.1,0.1.1,latest
# docker hub will use everything after the dash for the tags to apply to the img
# Usage
# From repo:
# ./ops/deploy.sh [deployprefix]
# where deployprefix is the name of one of the image subdirs, e.g pypyr or pypyr-go

# stop processing on any statement return != 0
set -eu

DEPLOYPREFIX=${1}
REPO=pypyr
echo "deploying: ${REPO}/${DEPLOYPREFIX}"
read -rsp $'Press enter to continue...\n'

# read the tags file from the image subdir
TAGS=$(< ${DEPLOYPREFIX}/tags)

echo the tags to apply to this image will be: ${TAGS}
read -rsp $'Press enter to continue...\n'

# ${TAGS} will look like this: latest,0.8,0.8.0
# assuming no spaces
echo will be building:
echo docker build -t ${REPO}/${DEPLOYPREFIX}:${TAGS//,/ -t ${REPO}/${DEPLOYPREFIX}:} -f ${DEPLOYPREFIX}/Dockerfile .
read -rsp $'Press enter to continue...\n'

# build
docker build -t ${REPO}/${DEPLOYPREFIX}:${TAGS//,/ -t ${REPO}/${DEPLOYPREFIX}:} -f ${DEPLOYPREFIX}/Dockerfile .

echo "build done for ${REPO}/${DEPLOYPREFIX}"
echo "running tests"
# test
. ${DEPLOYPREFIX}/hooks/test
echo "tests exit code: $?"
echo "tests done"

# git tag is pypyr-latest,0.1,0.1.1
TAG_NAME="${DEPLOYPREFIX}-${TAGS}"

echo about to create and push git tag: ${TAG_NAME}
read -rsp $'Press enter to continue...\n'

if [ $(git tag -l "${TAG_NAME}") ]; then
    echo "----------tag already exists.----------------------------------------"
else
    echo "version tag doesn't exist. create tag. ${TAG_NAME}"
    git tag "${TAG_NAME}"
    git push origin --tags
fi;

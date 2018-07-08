#!/usr/bin/env bash
# bumps pypyr version number throughout repo.
# usage
# from repo root:
# ./ops/bump-pypyr.sh [old] [new]
# example:
# ./ops/bump-pypyr.sh 0.8.1 0.8.2

# stop processing on any statement return != 0
set -eu

OLD=${1}
NEW=${2}

echo "updating ${OLD} to ${NEW}"
read -rsp $'Press enter to continue...\n'

# base image
sed -i "s/pypyrversion=${OLD}/pypyrversion=${NEW}/" pypyr/Dockerfile
sed -i "s/${OLD}/${NEW}/" pypyr/tags

# all tags except for base pypyr
sed -i "s/pypyr${OLD}-/pypyr${NEW}-/" ./pypyr-*/tags

# all test files
sed -i "s/pypyr ${OLD}/pypyr ${NEW}/" ./*/hooks/test

# all Dockerfiles except for the base pypyr
sed -i "s#pypyr/pypyr:${OLD}#pypyr/pypyr:${NEW}#" ./pypyr-*/Dockerfile

echo "git commit updating ${OLD} to ${NEW}"
read -rsp $'Press enter to continue...\n'

git commit -am "pypyr ${OLD} → ${NEW}"

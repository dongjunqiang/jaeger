#!/bin/bash

set -e

BRANCH=${BRANCH:?'missing BRANCH env var'}
IMAGE="${REPO:?'missing REPO env var'}:$BRANCH"

unset major minor patch
if [[ "$BRANCH" == "master" ]]; then
  TAG="latest"
elif [[ $BRANCH =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  major="${BASH_REMATCH[1]}"
  minor="${BASH_REMATCH[2]}"
  patch="${BASH_REMATCH[3]}"
  TAG=${major}.${minor}.${patch}
  echo "BRANCH is a release tag: major=$major, minor=$minor, patch=$patch"
else
  # TODO why do we do /// ?
  TAG="${BRANCH///}"
fi
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH, REPO=$REPO, BRANCH=$BRANCH, TAG=$TAG, IMAGE=$IMAGE"

# Do not enable echo before the `docker login` command to avoid revealing the password.
set -x
docker login -u $DOCKER_USER -p $DOCKER_PASS
# push all tags, therefore push to repo
docker push $REPO

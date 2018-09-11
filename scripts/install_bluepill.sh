#!/bin/sh

SCRIPT_PATH=$(cd $(dirname $0) && pwd)
PROJECT_ROOT_DIR="${SCRIPT_PATH}/.."
BLUE_PILL_DIR="${PROJECT_ROOT_DIR}/bluepill"

WORK_BRANCH=temp-working
BASE_TAG="2.4.0"

if [ ! -e "${BLUE_PILL_DIR}" ]; then
    git clone https://github.com/linkedin/bluepill.git
fi

cd "${BLUE_PILL_DIR}"

git fetch --prune

git branch -Df "${WORK_BRANCH}" 2> /dev/null
git checkout -b "${WORK_BRANCH}" 2> /dev/null
git reset --hard "tags/${BASE_TAG}"

./scripts/bluepill.sh build
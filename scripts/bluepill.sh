#!/bin/sh

if [ $# -ne 1 ]; then
    echo "\$ $0 UITest or UnitTest"
    exit
fi

SUFFIX=""
if [ $1 = "UITest" ]; then
    SUFFIX="-UITest"
elif [ $1 != "UnitTest" ]; then
    exit
fi

SCRIPT_PATH=$(cd $(dirname $0) && pwd)
PROJECT_ROOT_DIR="${SCRIPT_PATH}/.."
BUILD_DIR="${PROJECT_ROOT_DIR}/build"
PRODUCTS_DIR="${BUILD_DIR}/Build/Products"
BLUE_PILL_DIR="${PROJECT_ROOT_DIR}/bluepill"
BLUE_PILL_CMD_PATH="${BLUE_PILL_DIR}/build/Build/Products/Release/bluepill"
BULR_PILL_OUT_DIR="${BUILD_DIR}/bluepill_output"

XC_TEST_RUN_FILE_NAME=$(ls -l "${PRODUCTS_DIR}" | grep -oE "GitHubClientTestSample${SUFFIX}.*\.xctestrun$")
XC_TEST_RUN_PATH="${PRODUCTS_DIR}/${XC_TEST_RUN_FILE_NAME}"

echo "${XC_TEST_RUN_PATH}"
"${BLUE_PILL_CMD_PATH}" --xctestrun-path "${XC_TEST_RUN_PATH}" --output-dir "${BULR_PILL_OUT_DIR}" --num-sims 2
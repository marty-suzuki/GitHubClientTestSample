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

if [ -e "${BUILD_DIR}" ]; then
    rm -rf "${BUILD_DIR}"
fi

xcodebuild build-for-testing -scheme "GitHubClientTestSample${SUFFIX}" -derivedDataPath "${BUILD_DIR}" -workspace "${PROJECT_ROOT_DIR}/GitHubClientTestSample.xcworkspace" -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO
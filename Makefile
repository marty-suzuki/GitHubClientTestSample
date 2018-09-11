install:
	pod install
	carthage update --platform ios --no-use-binaries

build-for-ui-testing:
	xcodebuild build-for-testing -scheme GitHubClientTestSample-UITest -derivedDataPath ./build -workspace GitHubClientTestSample.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO

build-for-unit-testing:
	xcodebuild build-for-testing -scheme GitHubClientTestSample -derivedDataPath ./build -workspace GitHubClientTestSample.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' CODE_SIGN_IDENTITY=- CODE_SIGNING_REQUIRED=NO

ui-testing:
	bluepill --xctestrun-path ./build/Build/Products/GitHubClientTestSample-UITest_iphonesimulator11.4-x86_64.xctestrun --output-dir ./build/bluepill_output --num-sims 2

unit-testing:
	bluepill --xctestrun-path ./build/Build/Products/GitHubClientTestSample_iphonesimulator11.4-x86_64.xctestrun --output-dir ./build/bluepill_output --num-sims 2
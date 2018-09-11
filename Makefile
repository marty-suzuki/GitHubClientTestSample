install:
	pod install
	carthage update --platform ios --no-use-binaries

install-bluepill:
	./scripts/install_bluepill.sh

build-for-ui-testing:
	./scripts/build-for-testing.sh UITest

build-for-unit-testing:
	./scripts/build-for-testing.sh UnitTest

ui-testing-without-building:
	./scripts/bluepill.sh UITest

unit-testing-without-building:
	./scripts/bluepill.sh UnitTest

ui-testing:
	./scripts/build-for-testing.sh UITest
	./scripts/bluepill.sh UITest

unit-testing:
	./scripts/build-for-testing.sh UnitTest
	./scripts/bluepill.sh UnitTest
install:
	pod install
	carthage update --platform ios --no-use-binaries

test-macos:
	xcodebuild \
			-scheme FlexibleAttributedText \
			-destination platform="macOS"

test-ios:
	xcodebuild test \
			-scheme FlexibleAttributedText \
			-destination platform="iOS Simulator,name=iPhone 8"

test-tvos:
	xcodebuild test \
			-scheme FlexibleAttributedText \
			-destination platform="tvOS Simulator,name=Apple TV"

test: test-macos test-ios test-tvos

format:
	swift format --in-place --recursive .

.PHONY: format

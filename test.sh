#!/bin/bash
xcodebuild test \
-scheme AugmentedCampusIosTests \
-workspace AugmentedCampusIos.xcodeproj/project.xcworkspace \
-sdk iphonesimulator \
ONLY_ACTIVE_ARCH=NO \
-destination 'platform=iOS Simulator,name=iPhone 7,OS=11.0'
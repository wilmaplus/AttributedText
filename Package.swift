// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FlexibleAttributedText",
  platforms: [
    .macOS(.v11),
    .iOS(.v14),
    .tvOS(.v14),
  ],
  products: [
    .library(
      name: "FlexibleAttributedText",
      targets: ["FlexibleAttributedText"]
    )
  ],
  dependencies: [
    .package(
      name: "SnapshotTesting",
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.9.0"
    )
  ],
  targets: [
    .target(
      name: "FlexibleAttributedText",
      dependencies: []
    ),
    .testTarget(
      name: "FlexibleAttributedTextTests",
      dependencies: ["FlexibleAttributedText", "SnapshotTesting"],
      exclude: ["__Snapshots__"]
    ),
  ]
)

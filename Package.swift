// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VFont",
    platforms: [
        .macOS(.v11), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "VFont",
            targets: ["VFont"]),
    ],
    targets: [
        .target(
            name: "VFont",
            path: "Source/Framework")
    ]
)

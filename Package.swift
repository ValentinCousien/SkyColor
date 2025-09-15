// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkyColor",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SkyColor",
            targets: ["SkyColor"]),
    ],
    targets: [
        .target(
            name: "SkyColor"),
        .testTarget(
            name: "SkyColorTests",
            dependencies: ["SkyColor"])
    ]
)

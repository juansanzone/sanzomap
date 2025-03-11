// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]
        ),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [
                "Core"
            ]
        ),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services", "Core"]
        ),
    ]
)

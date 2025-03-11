// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapFeature",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MapFeature",
            targets: ["MapFeature"]
        ),
    ],
    dependencies: [
        .package(name: "Services", path: "../../Dependencies/Services"),
        .package(name: "CoreUI", path: "../../Dependencies/CoreUI"),
    ],
    targets: [
        .target(
            name: "MapFeature",
            dependencies: ["CoreUI", "Services"]
        ),
        .testTarget(
            name: "MapFeatureTests",
            dependencies: ["MapFeature", "Services"]
        ),
    ]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BSwiftUIKitNavigation",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "BSwiftUIKitNavigation",
                 targets: ["BSwiftUIKitNavigation"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BSwiftUIKitNavigation",
            dependencies: []),
        .testTarget(
            name: "BSwiftUIKitNavigationTests",
            dependencies: ["BSwiftUIKitNavigation"]),
    ]
)

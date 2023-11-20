// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EncryptedAppStorage",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "EncryptedAppStorage",
            targets: ["EncryptedAppStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "EncryptedAppStorage",
            dependencies: [
                .product(name: "KeychainAccess", package: "KeychainAccess"),
            ],
            path: "Sources"),
    ]
)

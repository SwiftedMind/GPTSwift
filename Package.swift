// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GPTSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "GPTSwift",
            targets: ["GPTSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get", from: "2.1.6")
    ],
    targets: [
        .target(
            name: "GPTSwift",
            dependencies: [
                .product(name: "Get", package: "Get")
            ])
    ]
)

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
            name: "ChatGPT",
            targets: ["ChatGPT"]
        ),
        .library(
            name: "GPT",
            targets: ["GPT"]
        ),
        .library(
            name: "OpenAI",
            targets: ["OpenAI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get", from: "2.1.6")
    ],
    targets: [
        .target(
            name: "Base",
            dependencies: [
                .product(name: "Get", package: "Get")
            ]
        ),
        .target(
            name: "ChatGPT",
            dependencies: [
                "Base",
                .product(name: "Get", package: "Get")
            ]
        ),
        .target(
            name: "GPT",
            dependencies: [
                "Base",
                .product(name: "Get", package: "Get")
            ]
        ),
        .target(
            name: "OpenAI",
            dependencies: [
                "Base",
                .product(name: "Get", package: "Get")
            ]
        )

    ]
)

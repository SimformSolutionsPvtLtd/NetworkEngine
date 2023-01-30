// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkEngine",
    products: [
        .library(
            name: "NetworkEngine",
            targets: ["NetworkEngine"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.2"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0")
    ],
    targets: [
        .target(
            name: "NetworkEngine",
            dependencies: [
                "Alamofire",
                .product(name: "Reachability", package: "Reachability.swift")
            ]
        ),
        .testTarget(
            name: "NetworkEngineTests",
            dependencies: ["NetworkEngine"]),
    ]
)

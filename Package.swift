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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.2")
    ],
    targets: [
        .target(
            name: "NetworkEngine",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "NetworkEngineTests",
            dependencies: ["NetworkEngine"]),
    ]
)

// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NetworkEngine",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "NetworkEngine",
            targets: ["NetworkEngine"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", "5.9.1"..<"5.12.0")
    ],
    targets: [
        .target(
            name: "NetworkEngine",
            dependencies: ["Alamofire"],
            path: "NetworkEngine",
            exclude: ["NetworkEngine.h"]
        ),
        .testTarget(
            name: "NetworkEngineTests",
            dependencies: ["NetworkEngine"],
            path: "NetworkEngineTests"
        )
    ]
)

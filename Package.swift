// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-fpcore",
    platforms: [
        .macOS("14.0"), .iOS("16.0"), .watchOS("9.0"), .tvOS("16.0"),
        .visionOS("1.0"),
    ],
    products: [
        .library(
            name: "FPCore",
            targets: ["FPCore"])
    ],
    dependencies: [  // View documentation locally with the following command
        // swift package --disable-sandbox preview-documentation --target FPCore
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.4.3")
    ],
    targets: [
        .target(
            name: "FPCore"),
        .testTarget(
            name: "FPCoreTests",
            dependencies: ["FPCore"]),
    ]
)

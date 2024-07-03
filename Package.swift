// swift-tools-version: 5.10

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
    dependencies: [
        /*
        Below are Package dependencies but not for output. Comment out if not
        needed for faster build times.
        */
        .package(
            url: "https://github.com/apple/swift-format.git",
            from: "510.1.0"),
        // View documentation locally with the following command
        // swift package --disable-sandbox preview-documentation --target FPCore
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "FPCore"),
        .testTarget(
            name: "FPCoreTests",
            dependencies: ["FPCore"]),
        .plugin(
            name: "SwiftFormatPlugin",
            capability: .command(
                intent: .custom(
                    verb: "format",
                    description: "format .scribe Swift Packages"),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "This command reformats swift source files")
                ]
            ),
            dependencies: [
                .product(name: "swift-format", package: "swift-format")
            ]
        ),
    ]
)

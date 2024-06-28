// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(name: "OpenTelemetryApi", targets: ["OpenTelemetryApi"]),
    ],
    targets: [
        .target(name: "OpenTelemetryApi",
                dependencies: []),
        .testTarget(name: "OpenTelemetryApiTests",
                    dependencies: ["OpenTelemetryApi"],
                    path: "Tests/OpenTelemetryApiTests")
    ]
)

// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v12),
        .visionOS(.v1),
        .watchOS(.v7)
    ],
    products: [
        .library(name: "OpenTelemetryApi", targets: ["OpenTelemetryApi"]),
    ],
    targets: [
        .target(name: "OpenTelemetryApi", dependencies: []),
    ]
)

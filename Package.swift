// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
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

if ProcessInfo.processInfo.environment["DD_XCODEBUILD_PATCH"] != nil {
    // Workaround for `xcodebuild` failing to detect `OpenTelemetryApi` as an individual target
    // when the package has only one library.
    //
    // Error message:
    // > The workspace named "opentelemetry-swift-packages" does not contain a scheme named "OpenTelemetryApi".
    //
    // To resolve this, we add a dummy "Empty" library, ensuring the package has more than one library.
    package.products.append(.library(name: "Empty", targets: ["Empty"]))
    package.targets.append(.target(name: "Empty", dependencies: []))
}

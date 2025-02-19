# opentelemetry-swift-packages

This repository provides multiple distribution options (XCFramework, CocoaPods, Carthage, and SwiftPM) for the `OpenTelemetryApi` library from [opentelemetry-swift](https://github.com/open-telemetry/opentelemetry-swift). It is tailored for the iOS platform versions supported by [dd-sdk-ios](https://github.com/DataDog/dd-sdk-ios).

It also hosts an API-only SwiftPM package to let SPM users integrate the OpenTelemetry API without pulling in the entire OpenTelemetry dependency tree. Versions here follow the official releases of [opentelemetry-swift](https://github.com/open-telemetry/opentelemetry-swift) and maintain the same versioning scheme.


## Installation

You can integrate OpenTelemetryApi using one of the following methods:

### XCFramework

Download the `.zip` file containing the `OpenTelemetryApi.xcframework` from the [Releases](https://github.com/DataDog/opentelemetry-swift-packages/releases) page and add it to your project.

### CocoaPods

```ruby
pod 'OpenTelemetrySwiftApi', '~> 1.13.0'
```

### Carthage

```ruby
binary "https://raw.githubusercontent.com/DataDog/opentelemetry-swift-packages/main/OpenTelemetryApi.json" ~> 1.13.0
```

### SPM

```swift
.package(url: "https://github.com/DataDog/opentelemetry-swift-packages.git", .upToNextMinor(from: "1.13.0")),
```

## Contributing

Before considering contributions to the project, please take a moment to read
our brief [contribution guidelines](CONTRIBUTING.md).

## License

[Apache License, v2.0](LICENSE)
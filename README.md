# opentelemetry-swift-packages

[![Automation](https://github.com/DataDog/opentelemetry-swift-packages/actions/workflows/automation.yaml/badge.svg)](https://github.com/DataDog/opentelemetry-swift-packages/actions/workflows/automation.yaml?query=event%3Aschedule+branch%3Amain)

[dd-sdk-ios](https://github.com/DataDog/dd-sdk-ios) uses the OpenTelemetry APIs
for Tracing which are provided by the `OpenTelemetryApi` package in
[opentelemetry-swift](https://github.com/open-telemetry/opentelemetry-swift).
dd-sdk-ios supports Swift Package Manager (SPM), XCFramework, CocoaPods, and
Carthage but OpenTelemetry only provides the SPM package support. This
repository fills the gap by providing the XCFramework, CocoaPods, and Carthage
packages for the OpenTelemetryApi package. Also, hosts API only SPM package
which allows SPM users to use the API package without cloning the OpenTelemetry
repository. It uses the official releases from opentelemetry-swift and maintains
the same versioning scheme.

## Usage

## Automation workflow

The `automation` workflow is setup for running every day and it checks for new
version release of the OpenTelemetry Swift libraries. If a new version is found,
it will build the new version using the tag, package it as XCFramework, and push
it to the releases, and update the CocoaPods and Carthage specs.

### XCFramework

You can download the XCFramework from the
[releases](https://github.com/DataDog/opentelemetry-swift-packages/releases)
page and add it to your project.

### CocoaPods

```ruby
pod 'OpenTelemetrySwiftApi', '~> 1.9.1'
```

### Carthage

```ruby
binary "https://raw.githubusercontent.com/DataDog/opentelemetry-swift-packages/main/OpenTelemetryApi.json" ~> 1.9.1
```

## SPM

```swift
.package(url: "https://github.com/DataDog/opentelemetry-swift-packages.git", .upToNextMinor(from: "1.9.1")),
```

You can import a specific version of the package by copy-pasting source code
from the
[releases](https://github.com/open-telemetry/opentelemetry-swift/releases). Make
sure to use the same version as the OpenTelemetry release.

## Contributing

Before considering contributions to the project, please take a moment to read
our brief [contribution guidelines](CONTRIBUTING.md).

## License

[Apache License, v2.0](LICENSE)
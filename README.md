# opentelemetry-swift-packages

This repository provides Carthage and XCFramework distribution options for the `OpenTelemetryApi` library from [opentelemetry-swift-core](https://github.com/open-telemetry/opentelemetry-swift-core). It is tailored for the iOS platform versions supported by [dd-sdk-ios](https://github.com/DataDog/dd-sdk-ios).


## Installation

You can integrate OpenTelemetryApi using one of the following methods:

### XCFramework

Download the `.zip` file containing the `OpenTelemetryApi.xcframework` from the [Releases](https://github.com/DataDog/opentelemetry-swift-packages/releases) page and add it to your project.

### Carthage

```ruby
binary "https://raw.githubusercontent.com/DataDog/opentelemetry-swift-packages/main/OpenTelemetryApi.json" ~> 1.13.0
```

## Contributing

Before considering contributions to the project, please take a moment to read
our brief [contribution guidelines](CONTRIBUTING.md).

## Release Process

For detailed instructions on how to release a new version of `OpenTelemetryApi` in this repo, refer to the [Release Workflow](RELEASE.md).

## License

[Apache License, v2.0](LICENSE)
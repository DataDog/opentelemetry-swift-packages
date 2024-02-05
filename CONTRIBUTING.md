Thanks for your interest in contributing! This is an open source project, so we
appreciate community contributions.

Pull requests for bug fixes are welcome, but before submitting new features or
changes to current functionalities [open an
issue](https://github.com/DataDog/opentelemetry-swift-packages/issues/new) and
discuss your ideas or propose the changes you wish to make. After a resolution
is reached a PR can be submitted for review. PRs created before a decision has
been reached may be closed.

For commit messages, try to use the conventional commit format.

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## PR Checks

We expect all PR checks to pass before we merge a PR, which can be investigated
by following the Details links to the GitHub Actions checks.

## Local Development

### Prerequisites

- Xcode 14.0 or later
- Swift 5.7 or later
- CocoaPods 1.10.0 or later

This project mainly contains automation scripts to build and release the
OpenTelemetry Swift libraries. You can run all scripts locally to test the
changes before creating a PR. Check the usage methods in the automation scripts
to run them locally.
# Release Workflow

This document outlines the steps required to release a new version of `OpenTelemetryApi` in this repository.

## Prerequisites

Before starting the release process, ensure that you have the [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated. You can check your authentication status with:
```
gh auth status
```
If you are not authenticated, log in using:
```
gh auth login
```

## 1. Prepare the Code Update

This step is **manual**. It involves importing the latest `OpenTelemetryApi` code from upstream and preparing a pull request for review.

- Create a new branch.
- Import the `OpenTelemetryApi` code from the desired release (`x.y.z`) of [`opentelemetry-swift-core`](https://github.com/open-telemetry/opentelemetry-swift-core/releases).
- Copy the new version's code into `Sources/OpenTelemetryApi/`
- Create a PR with the changes.

Once reviewed and approved, merge the PR into the `main` branch.

## 2. Tag the Release

This step is **manual**. It involves creating a version tag to mark the imported code as an official release candidate.
- After the PR is merged, on the recent `main` commit, create a new Git tag matching the imported version:
```
git tag x.y.z
git push origin x.y.z
```
- This triggers the CI workflow to build and package the XCFramework.

## 3. Automatic Release Process

This step is fully **automated**. Once a tag is pushed, GitHub Actions will build the framework and publish it as a GitHub release.

Once the tag is pushed, the CI workflow will:
- Build the `OpenTelemetryApi` XCFramework.
- Upload `OpenTelemetryApi.zip` as an artifact.
- Create a GitHub Release in [`DataDog/opentelemetry-swift-packages`](https://github.com/DataDog/opentelemetry-swift-packages/releases).
- Attach `OpenTelemetryApi.zip` to the GitHub Release.

## 4. Update Carthage Version

This step is *manual*. It requires running a script locally to update the version for Carthage and create a pull request.

- Pull the latest changes from main:
```
git checkout main
git pull origin main
```
- Run the version bump script locally:
```
make bump-carthage-version VERSION=x.y.z
```

- This will:
   - Create a new branch `bump-carthage-to-x.y.z`.
   - Update the Carthage spec file.
   - Create a PR for publishing the updated version.
   - Submit the PR for review and approval.

## 5. Final Steps

Last, verify that the release has been successfully deployed and is available in all distribution channels.
- The version of OpenTelemetryApi must be updated in [`DataDog/dd-sdk-ios`](https://github.com/DataDog/dd-sdk-ios).
- Smoke tests in `dd-sdk-ios` will ensure that the new version is available via Carthage and XCFramework.

The release process is now complete 🏅!

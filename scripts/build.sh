#!/bin/bash

set -e

source="../opentelemetry-swift"
target="OpenTelemetryApi"

# Usage function
function usage() {
    echo "Usage: $0 [-s <source>] [-t <target>]"
    echo "  -s, --source    Specify the source directory"
    echo "  -t, --target    Specify the target directory"
    echo "  -h, --help      Display this help message"
    exit 0
}

# Parse command-line arguments
while (( "$#" )); do
    case "$1" in
        -s|--source)
                source="$2"
                shift 2
                ;;
        -t|--target)
                target="$2"
                shift 2
                ;;
        -h|--help)
                usage
                ;;
        --) # end argument parsing
            shift
            break
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

echo "Source: $source"
echo "Target: $target"

# Replace all type: .static with .dynamic
# Static libraries can't be bundled into xcframeworks hence the need to replace them with dynamic libraries
function update_package_swift() {
    file=$1
    echo "Updating $file"
    sed -i '' 's/.static/.dynamic/g' $file
}

# Build the scheme for the platform
function build() {
    scheme=$1
    platform=$2
    echo "Building $scheme for $platform"
    xcodebuild archive -workspace $source \
        -scheme $scheme \
        -destination "generic/platform=$platform" \
        -archivePath "archives/$scheme/$platform" \
        -derivedDataPath ".build" \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        | xcpretty
    echo "Done building $scheme for $platform"
}

# Create xcframework from the archives
function package() {
    scheme=$1
    shift
    platforms=("$@")

    args=()
    for platform in "${platforms[@]}"; do
        echo "Adding $platform to $scheme.xcframework"

        framework_path="archives/$scheme/$platform.xcarchive/Products/usr/local/lib/$scheme.framework"

        # For some reason, the dsym path needs to be absolute, else framework creation fails
        dsym_path=`readlink -f "archives/$scheme/$platform.xcarchive/dSYMs/$scheme.framework.dSYM"`

        args+=("-framework" "$framework_path" "-debug-symbols" "$dsym_path")
    done

    echo "Removing archives/$scheme.xcframework"
    rm -rf "frameworks/$scheme.xcframework"

    echo "Creating $scheme.xcframework"
    xcodebuild -create-xcframework "${args[@]}" -output "frameworks/$scheme.xcframework" | xcpretty
    echo "Done creating $scheme.xcframework"
}

# Zip the xcframework
function compress() {
    scheme=$1
    echo "Removing artifacts/$scheme.xcframework.zip"
    rm -rf "artifacts/$scheme.xcframework.zip"

    echo "Zipping $scheme.xcframework"
    mkdir -p "artifacts"

    # by default zip will include the full path of the files in the zip file
    # -j will not include the path but it doesn't work with -r
    pushd "frameworks/$scheme.xcframework"
    zip -r "../../artifacts/$scheme.xcframework.zip" *
    popd
    echo "Done zipping $scheme.xcframework"
}

platforms=(
    "iOS"
    "iOS Simulator"
    "tvOS"
    "tvOS Simulator"
)

update_package_swift "$source/Package.swift"
update_package_swift "$source/Package@swift-5.6.swift"
update_package_swift "$source/Package@swift-5.9.swift"

for platform in "${platforms[@]}"; do
    build $target "$platform"
done

package $target "${platforms[@]}"
compress $target

#!/bin/bash

set -e

# Usage function
function usage() {
    echo "Usage: $0 [-v <version>]"
    echo "  -v, --version   Specify the version"
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
        -v|--version)
                version="$2"
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

# Check required arguments
if [ -z "$version" ]; then
    echo "Error: Missing version"
    usage
fi

echo "Version: $version"

gh release create $version \
    artifacts/OpenTelemetryApi.xcframework.zip \
    --title "OpenTelemetry Swift $version" \
    --notes-file artifacts/release_notes.md

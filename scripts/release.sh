#!/bin/bash

set -e

cartage_spec_OpenTelemetryApi="OpenTelemetryApi.json"

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

# Appends "{version}": "{framework path}" to the json file
# before
# {
#     "1.9.1": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.1/OpenTelemetryApi.xcframework.zip"
# }
# after
# {
#     "1.9.2": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.2/OpenTelemetryApi.xcframework.zip"
#     "1.9.1": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.1/OpenTelemetryApi.xcframework.zip"
# }
function update_cartage_binary_project_spec() {
    file=$1
    version=$2
    url="https://github.com/DataDog/opentelemetry-swift-packages/releases/download/$version/OpenTelemetryApi.xcframework.zip"
    echo "Updating $file"
    jq --arg version "$version" --arg url "$url" '. + {($version): $url}' $file > tmp.json && mv tmp.json $file
    echo "Updated $file"
    cat $file
}

function commit_and_push() {
    git add $cartage_spec_OpenTelemetryApi
    # check if there are any changes
    if [[ -z $(git status -s) ]]; then
        echo "No changes to commit"
        exit 0
    fi
    git commit -m "chore: Release $version"
    git push
}

gh release create $version \
    artifacts/OpenTelemetryApi.xcframework.zip \
    --title "OpenTelemetry Swift $version" \
    --notes-file artifacts/release_notes.md

update_cartage_binary_project_spec $cartage_spec_OpenTelemetryApi $version
commit_and_push
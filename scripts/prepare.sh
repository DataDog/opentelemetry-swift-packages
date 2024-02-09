#!/bin/bash

set -e

cartage_spec_OpenTelemetryApi="OpenTelemetryApi.json"
podspec_OpenTelemetryApi="OpenTelemetrySwiftApi.podspec"

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
#     "1.9.1": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.1/OpenTelemetryApi.zip"
# }
# after
# {
#     "1.9.2": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.2/OpenTelemetryApi.zip"
#     "1.9.1": "https://github.com/DataDog/opentelemetry-swift-packages/releases/download/1.9.1/OpenTelemetryApi.zip"
# }
function update_cartage_binary_project_spec() {
    file=$1
    version=$2
    url="https://github.com/DataDog/opentelemetry-swift-packages/releases/download/$version/OpenTelemetryApi.zip"
    echo "Updating $file"
    jq --arg version "$version" --arg url "$url" '. + {($version): $url}' $file > tmp.json && mv tmp.json $file
    echo "Updated $file"
    cat $file
}

function commit_push() {
    git add $cartage_spec_OpenTelemetryApi
    git add $podspec_OpenTelemetryApi
    # check if there are any changes
    if [[ -z $(git status -s) ]]; then
        echo "No changes to commit"
        exit 0
    fi
    git commit -m "chore: Release $version"
    git push
}

# Updates the version and sha1 in the podspec file
function update_podspec() {
    podspec_file=$1
    version=$2
    sha1=$3

    # update version
    #  s.version = "1.9.1" to s.version = "1.9.2"
    sed -i '' "s|s.version = \".*\"|s.version = \"$version\"|g" $podspec_file

    # update sha1
    #  sha1: "34156dcaa4be3cc1d95a7d4c2bc792cb30405b2a" to sha1: "07b738438d7a88be3d3cd89656af350702824b8e"
    sed -i '' "s|sha1: \".*\"|sha1: \"$sha1\"|g" $podspec_file

    echo "Updated $podspec_file"
    cat $podspec_file
}

update_cartage_binary_project_spec $cartage_spec_OpenTelemetryApi $version

sha1=$(shasum -a 1 artifacts/OpenTelemetryApi.zip | awk '{print $1}')
update_podspec $podspec_OpenTelemetryApi $version $sha1

commit_push

echo "Checking if the github release $version exists"
if gh release view $version > /dev/null; then
    echo "Github release $version exists"
else
    echo "Github release $version does not exist"
    echo "Creating github draft release $version"
    gh release create $version \
        artifacts/OpenTelemetryApi.zip \
        --title "OpenTelemetry Swift $version" \
        --notes-file artifacts/release_notes.md
fi
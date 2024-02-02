# Usage function
function usage() {
    echo "Usage: $0 [-v <version>]"
    echo "  -v, --version   Specify the version"
    echo "  -h, --help      Display this help message"
    exit 0
}

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

git push
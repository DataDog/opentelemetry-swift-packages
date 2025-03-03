#!/bin/zsh

set -e
source ./scripts/utils/echo-color.sh

# Usage function
function usage() {
    echo "Usage: $0 [-v <version>]"
    echo "  -v, --version   Specify the version"
    echo "  -h, --help      Display this help message"
    exit 0
}

while (( "$#" )); do
    case "$1" in
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

echo_info "Checking if the github release $version exists"
if gh release view $version > /dev/null; then
    echo_err "Github release $version exists"
else
    echo_info "Github release $version does not exist"
    echo "Creating github draft release $version"
    gh release create $version \
        artifacts/OpenTelemetryApi.zip \
        --title "$version" \
        --notes-file artifacts/version_info.md
fi

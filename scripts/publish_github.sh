#!/bin/zsh

set -e
source ./scripts/utils/echo-color.sh

update=false

# Usage function
function usage() {
    echo "Usage: $0 [-v <version>] [--update]"
    echo "  -v, --version   Specify the version"
    echo "  -u, --update    Update assets and notes of an existing release"
    echo "  -h, --help      Display this help message"
    exit 0
}

while (( "$#" )); do
    case "$1" in
        -v|--version)
                version="$2"
                shift 2
                ;;
        -u|--update)
                update=true
                shift
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
if gh release view $version > /dev/null 2>&1; then
    if [ "$update" = true ]; then
        echo_info "Updating existing github release $version"
        gh release upload $version artifacts/OpenTelemetryApi.zip --clobber
        gh release edit $version --notes-file artifacts/version_info.md
    else
        echo_err "Github release $version already exists. Use --update to replace its assets."
        exit 1
    fi
else
    echo_info "Creating github draft release $version"
    gh release create $version \
        artifacts/OpenTelemetryApi.zip \
        --title "$version" \
        --notes-file artifacts/version_info.md
fi

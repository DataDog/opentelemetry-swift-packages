#!/bin/zsh

set -e
source ./scripts/utils/echo-color.sh

pod_name_OpenTelemetryApi="OpenTelemetrySwiftApi"

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

# Check required arguments
if [ -z "$version" ]; then
    echo "Error: Missing version"
    usage
fi

echo "Version: $version"

echo_info "Checking if pod $pod_name_OpenTelemetryApi version $version exists"

if pod trunk info $pod_name_OpenTelemetryApi | grep -q "$version"; then
    echo_warn "Pod $pod_name_OpenTelemetryApi version $version exists"
else
    echo_info "Pod $pod_name_OpenTelemetryApi version $version does not exist"
    echo_info "Updating pod $pod_name_OpenTelemetryApi version $version"
    pod trunk push $pod_name_OpenTelemetryApi.podspec --allow-warnings --verbose
fi

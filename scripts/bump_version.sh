#!/bin/zsh

set -e
source ./scripts/utils/echo-color.sh

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
        -v|--version)
            version="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        -*|--*=)
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
        *)
            shift
            ;;
    esac
done

# Check required arguments
if [ -z "$version" ]; then
    echo "Error: Missing version"
    usage
fi

echo_info "Version: $version"

echo_info "Verifying GitHub CLI authentication (run 'gh auth login' if not authenticated)..."
gh auth status

# Ensure we are on the `main` branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" ]]; then
    echo_err "Error: You must be on the 'main' branch to run this script."
    exit 1
fi

# Create the new branch
branch_name="bump-carthage-to-$version"
echo_info "Creating branch: $branch_name"
git checkout -b "$branch_name"

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

    echo_info "Updating '$file' to version: '$version'"
    url="https://github.com/DataDog/opentelemetry-swift-packages/releases/download/$version/OpenTelemetryApi.zip"
    jq --arg version "$version" --arg url "$url" '. + {($version): $url}' "$file" > tmp.json && mv tmp.json "$file"

    echo_succ "Updated $file:"
    echo "------------- BEGIN"
    cat "$file"
    echo "------------- END"
}

# Commit the changes
function commit() {
    echo_info "Staging changes for commit..."
    git add "$cartage_spec_OpenTelemetryApi"

    if [[ -z $(git status -s) ]]; then
        echo_warn "No changes detected. Nothing to commit."
        exit 0
    fi

    git commit -m "chore: Update Carthage release to $version"
    echo_succ "Commit successful!"
}

# Push the branch and create a PR
function create_pr() {
    echo_info "Pushing branch '$branch_name'"
    git push origin "$branch_name"

    echo_info "Creating a pull request..."
    gh pr create --title "chore: Bump Carthage to $version" \
                 --body "This PR updates Carthage to version $version." \
                 --base main --head "$branch_name"

    echo_succ "Pull request created successfully!"
}

update_cartage_binary_project_spec "$cartage_spec_OpenTelemetryApi" "$version"
commit
create_pr

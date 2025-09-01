#!/bin/bash
# generate-oci-labels.sh - Generate standardized OCI labels for Crossplane providers
# Version: 2025-09-01
#
# Usage: 
#   ./generate-oci-labels.sh provider-name "Provider description"
#   source generate-oci-labels.sh provider-name "Provider description"
#
# Output: Space-separated --label arguments for docker build

set -euo pipefail

# Check if we have required arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <provider-name> <description>" >&2
    echo "Example: $0 provider-mailgun 'Mailgun email service management'" >&2
    exit 1
fi

PROVIDER_NAME="$1"
DESCRIPTION="$2"

# Get current timestamp in RFC3339 format
CREATED=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

# Generate standardized OCI labels
# Reference: https://specs.opencontainers.org/image-spec/annotations/
LABELS=(
    "--label org.opencontainers.image.title=${PROVIDER_NAME}"
    "--label org.opencontainers.image.description=Crossplane provider for ${DESCRIPTION}"
    "--label org.opencontainers.image.vendor=rossigee"
    "--label org.opencontainers.image.licenses=Apache-2.0"
    "--label org.opencontainers.image.created=${CREATED}"
)

# Add version-specific labels if VERSION is set
if [ -n "${VERSION:-}" ]; then
    LABELS+=(
        "--label org.opencontainers.image.version=${VERSION}"
        "--label org.opencontainers.image.ref.name=${VERSION}"
    )
fi

# Add git-specific labels if in CI environment
if [ -n "${GITHUB_SHA:-}" ]; then
    LABELS+=(
        "--label org.opencontainers.image.revision=${GITHUB_SHA}"
    )
fi

if [ -n "${GITHUB_SERVER_URL:-}${GITHUB_REPOSITORY:-}" ]; then
    REPO_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
    LABELS+=(
        "--label org.opencontainers.image.source=${REPO_URL}"
        "--label org.opencontainers.image.url=${REPO_URL}"
    )
    
    # Add documentation URL with version-specific path if available
    if [ -n "${VERSION:-}" ]; then
        LABELS+=(
            "--label org.opencontainers.image.documentation=${REPO_URL}/blob/${VERSION}/README.md"
        )
    else
        LABELS+=(
            "--label org.opencontainers.image.documentation=${REPO_URL}/blob/master/README.md"
        )
    fi
fi

# Output labels (space-separated for use in docker build)
printf '%s\n' "${LABELS[@]}"

# If sourced, export as environment variable for reuse
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    export OCI_LABELS="${LABELS[*]}"
fi
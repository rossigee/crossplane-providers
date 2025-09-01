#!/bin/bash
# add-oci-labels-to-dockerfiles.sh - Add OCI labels to all provider Dockerfiles
# Version: 2025-09-01

set -euo pipefail

# Provider configurations: name and description
declare -A PROVIDERS=(
    ["provider-btcpay"]="BTCPay Server management (stores, invoices, webhooks)"
    ["provider-signoz"]="SigNoz observability platform management"
    ["provider-libvirt"]="KVM/libvirt virtual machine provisioning"
    ["provider-minio"]="MinIO object storage (buckets, users, policies)"
    ["provider-harbor"]="Harbor container registry management"
    ["provider-http"]="Generic HTTP request resources"
    ["provider-openstack"]="OpenStack cloud resources"
    ["provider-discord"]="Discord server management"
    ["provider-gitea"]="Gitea repository management"
    ["provider-matrix"]="Matrix chat server management"
    ["provider-backblaze"]="Backblaze B2 cloud storage"
    ["provider-cloudflare"]="Cloudflare DNS and security services"
    ["provider-gitea-native"]="Gitea repository management (native implementation)"
    ["provider-docker"]="Docker container and image management"
)

# OCI labels template
generate_labels() {
    local provider_name="$1"
    local description="$2"
    
    cat << EOF

# OpenContainers Image Spec Labels
LABEL org.opencontainers.image.title="${provider_name}"
LABEL org.opencontainers.image.description="Crossplane provider for ${description}"
LABEL org.opencontainers.image.vendor="rossigee"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/rossigee/${provider_name}"
LABEL org.opencontainers.image.url="https://github.com/rossigee/${provider_name}"
LABEL org.opencontainers.image.documentation="https://github.com/rossigee/${provider_name}/blob/master/README.md"
EOF
}

# Function to update a Dockerfile
update_dockerfile() {
    local dockerfile="$1"
    local provider_name="$2"
    local description="$3"
    
    if [ ! -f "$dockerfile" ]; then
        echo "⚠️  Dockerfile not found: $dockerfile"
        return 1
    fi
    
    # Check if already has OCI labels
    if grep -q "org.opencontainers.image" "$dockerfile"; then
        echo "✅ $dockerfile already has OCI labels"
        return 0
    fi
    
    echo "📝 Updating $dockerfile..."
    
    # Create temporary file
    local temp_file=$(mktemp)
    
    # Find the position to insert labels (after FROM, before first ARG)
    awk -v labels="$(generate_labels "$provider_name" "$description")" '
    BEGIN { labels_inserted = 0 }
    
    # After FROM line and any RUN commands, insert labels before first ARG
    /^FROM/ { 
        print; 
        getline;
        # Print any RUN commands that might follow FROM
        while ($0 ~ /^RUN/ || $0 ~ /^$/) {
            print;
            if (getline <= 0) break;
        }
        # Insert labels here
        print labels;
        labels_inserted = 1;
    }
    
    # Print all other lines normally
    { 
        if (!labels_inserted || ($0 !~ /^FROM/)) {
            print;
        }
    }
    ' "$dockerfile" > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$dockerfile"
    
    echo "✅ Updated $dockerfile"
}

# Update all provider Dockerfiles
echo "🚀 Adding OpenContainers labels to all provider Dockerfiles..."
echo ""

updated_count=0
skipped_count=0

for provider in "${!PROVIDERS[@]}"; do
    description="${PROVIDERS[$provider]}"
    
    # Find the main Dockerfile for this provider
    dockerfile="$provider/cluster/images/$provider/Dockerfile"
    
    if update_dockerfile "$dockerfile" "$provider" "$description"; then
        ((updated_count++))
    else
        ((skipped_count++))
    fi
done

# Handle special cases with different paths
special_cases=(
    "provider-matrix/Dockerfile:provider-matrix:Matrix chat server management"
    "provider-gitea-native/Dockerfile:provider-gitea-native:Gitea repository management (native implementation)"
    "provider-cloudflare/Dockerfile:provider-cloudflare:Cloudflare DNS and security services"
)

echo ""
echo "🔍 Checking special case Dockerfiles..."

for case in "${special_cases[@]}"; do
    IFS=':' read -r dockerfile provider_name description <<< "$case"
    
    if update_dockerfile "$dockerfile" "$provider_name" "$description"; then
        ((updated_count++))
    else
        ((skipped_count++))
    fi
done

echo ""
echo "📊 Summary:"
echo "   Updated: $updated_count Dockerfiles"
echo "   Skipped: $skipped_count Dockerfiles"
echo ""
echo "✅ All Dockerfiles have been processed!"
echo ""
echo "💡 Note: Dynamic labels (version, revision, created) are added during"
echo "   CI/CD build process via --label arguments in release workflow."
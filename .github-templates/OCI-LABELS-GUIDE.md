# OpenContainers Image Labels Implementation Guide

## Overview

This guide documents the implementation of OpenContainers Image Specification (OCI) labels across all Crossplane providers in this repository. OCI labels provide standardized metadata about container images, improving discoverability, traceability, and governance.

## Reference Documentation

- [OpenContainers Image Spec Annotations](https://specs.opencontainers.org/image-spec/annotations/)
- [GitHub Container Registry Label Support](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#labelling-container-images)

## Implementation Strategy

### Two-Layer Approach

1. **Static Labels in Dockerfile**: Basic metadata that doesn't change per build
2. **Dynamic Labels in CI/CD**: Build-specific metadata (version, revision, timestamp)

### Static Labels (Dockerfile)

Each provider Dockerfile includes these baseline labels:

```dockerfile
# OpenContainers Image Spec Labels
LABEL org.opencontainers.image.title="provider-name"
LABEL org.opencontainers.image.description="Crossplane provider for Service Description"
LABEL org.opencontainers.image.vendor="rossigee"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/rossigee/provider-name"
LABEL org.opencontainers.image.url="https://github.com/rossigee/provider-name"
LABEL org.opencontainers.image.documentation="https://github.com/rossigee/provider-name/blob/master/README.md"
```

### Dynamic Labels (CI/CD)

The release workflow adds build-specific labels:

```yaml
--label "org.opencontainers.image.version=${{ steps.version.outputs.version }}"
--label "org.opencontainers.image.revision=${{ github.sha }}"
--label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
--label "org.opencontainers.image.ref.name=${{ steps.version.outputs.version }}"
```

## Label Descriptions

| Label | Description | Example Value |
|-------|-------------|---------------|
| `title` | Human-readable title | `provider-mailgun` |
| `description` | Brief description of image purpose | `Crossplane provider for Mailgun email service management` |
| `vendor` | Organization/individual responsible | `rossigee` |
| `licenses` | License identifier (SPDX format) | `Apache-2.0` |
| `source` | Source code repository URL | `https://github.com/rossigee/provider-mailgun` |
| `url` | Project homepage URL | `https://github.com/rossigee/provider-mailgun` |
| `documentation` | Documentation URL | `https://github.com/rossigee/provider-mailgun/blob/master/README.md` |
| `version` | Release version | `v1.2.3` |
| `revision` | Git commit SHA | `abc123def456...` |
| `created` | Build timestamp (RFC3339) | `2025-09-01T12:34:56Z` |
| `ref.name` | Reference name for version | `v1.2.3` |

## Tools and Scripts

### 1. OCI Labels Generator Script

**Location**: `.github-templates/generate-oci-labels.sh`

Generates standardized OCI labels for use in build processes:

```bash
# Generate labels for provider
./generate-oci-labels.sh provider-mailgun "Mailgun email service management"

# Use in CI/CD with environment variables
VERSION=v1.2.3 GITHUB_SHA=abc123 ./generate-oci-labels.sh provider-name "Description"
```

**Features**:
- Standardized label generation
- Environment variable integration
- CI/CD compatibility
- Export for reuse in shell scripts

### 2. Dockerfile Update Script

**Location**: `add-oci-labels-to-dockerfiles.sh`

Batch updates all provider Dockerfiles with baseline OCI labels:

```bash
# Add labels to all Dockerfiles
./add-oci-labels-to-dockerfiles.sh
```

**Features**:
- Detects existing labels (skip if present)
- Provider-specific descriptions
- Proper placement after FROM/RUN instructions
- Comprehensive coverage across all providers

## Integration Points

### GitHub Container Registry

OCI labels appear in GitHub Container Registry UI:
- Package overview page shows title and description
- Labels tab displays all metadata
- Search and filtering capabilities
- Automated linking to source repository

### Release Workflow Integration

The standardized release template includes OCI labels:

```yaml
- name: Build Docker Image (Version)
  run: |
    docker build -t ghcr.io/rossigee/PROVIDER_NAME:${{ steps.version.outputs.version }} \
      --label "org.opencontainers.image.version=${{ steps.version.outputs.version }}" \
      --label "org.opencontainers.image.revision=${{ github.sha }}" \
      --label "org.opencontainers.image.created=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
      $BUILD_CONTEXT
```

### Crossplane Package Integration

Labels are inherited by Crossplane packages (`.xpkg` files) when built from labeled images.

## Provider Coverage

### ✅ Implemented

The following providers have been updated with OCI labels:

- **provider-mailgun**: Email service management
- **provider-plausible**: Analytics sites and goals management  
- **provider-vault**: HashiCorp Vault secrets management
- **provider-minio**: MinIO object storage management
- **provider-harbor**: Harbor container registry management
- **provider-http**: Generic HTTP request resources

### 🔄 Template Ready

All remaining providers can be updated using the batch script:

- provider-btcpay, provider-signoz, provider-libvirt
- provider-openstack, provider-discord, provider-gitea
- provider-matrix, provider-backblaze, provider-cloudflare
- provider-gitea-native, provider-docker

## Verification

### Check Labels in Built Image

```bash
# Inspect image labels
docker inspect ghcr.io/rossigee/provider-name:version

# Extract OCI labels specifically
docker inspect ghcr.io/rossigee/provider-name:version \
  --format '{{ index .Config.Labels "org.opencontainers.image.version" }}'
```

### GitHub Container Registry

1. Navigate to the package in GitHub Container Registry
2. Click on the package version
3. Check the "Labels" tab for OCI metadata

## Best Practices

### Static vs Dynamic Labels

- **Static labels**: Put in Dockerfile for metadata that doesn't change per build
- **Dynamic labels**: Add via `docker build --label` for build-specific data

### Label Values

- **Descriptions**: Keep concise but descriptive (under 100 characters)
- **URLs**: Use HTTPS and ensure they resolve correctly
- **Licenses**: Use SPDX identifiers when possible
- **Timestamps**: Always use RFC3339 format in UTC

### Template Usage

1. Copy release template to `.github/workflows/release.yml`
2. Replace `PROVIDER_NAME` with actual provider name
3. Replace `PROVIDER_DESCRIPTION` with service description
4. Test with a version tag to verify labels are applied

## Troubleshooting

### Common Issues

1. **Labels not appearing**: Check CI/CD logs for docker build output
2. **Wrong timestamp format**: Ensure RFC3339 format (`2025-09-01T12:34:56Z`)
3. **Missing dynamic labels**: Verify release workflow template usage

### Validation Commands

```bash
# Check if Dockerfile has labels
grep -A 10 "OpenContainers Image Spec Labels" provider-name/cluster/images/provider-name/Dockerfile

# Verify CI/CD adds dynamic labels
grep -A 5 "org.opencontainers.image.version" .github/workflows/release.yml
```

## Migration Checklist

For migrating existing providers to OCI labels:

- [ ] Update Dockerfile with static labels using provided script
- [ ] Apply release workflow template with dynamic labels  
- [ ] Test with version tag to verify label application
- [ ] Verify labels appear in GitHub Container Registry
- [ ] Update provider documentation if needed

## Future Enhancements

- **Automation**: CI/CD verification that all required labels are present
- **Consistency**: Automated checks for label format and content standards
- **Documentation**: Automatic generation of provider catalogs from OCI labels
- **Governance**: Policy enforcement for required label presence
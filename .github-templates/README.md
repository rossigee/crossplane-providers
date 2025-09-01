# Standardized CI/CD Templates for Crossplane Providers

**Version**: 2025-08-14  
**Status**: ✅ Applied to provider-mailgun, ready for rollout

## Overview

This directory contains standardized CI/CD templates that implement the **"CI Builds, Release Publishes"** pattern to eliminate tag conflicts and ensure consistent publishing across all Crossplane providers.

## Problem Solved

**Before**: CI and Release workflows were both publishing images, causing:
- `latest` and version tags pointing to different images
- Inconsistent build processes across providers
- Registry conflicts and deployment issues

**After**: Clean separation of responsibilities:
- **CI**: Build validation only (no publishing)
- **Release**: All publishing (version + latest from same image)

## Template Files

### `ci-template.yml`
- **Purpose**: Continuous integration for all commits and PRs
- **Triggers**: Push to master/release branches, PRs, manual dispatch
- **Jobs**: lint, check-diff, unit-tests, security-scan, build-validation
- **Key Feature**: Build validation only - NO PUBLISHING

### `release-template.yml`
- **Purpose**: Release automation on version tags
- **Triggers**: Push to tags matching `v*`
- **Key Feature**: Single source of truth for all publishing
- **Critical**: Version and latest tags point to SAME image

## Key Principles

### 1. Single Source of Truth for Publishing
```yaml
# CI workflow: Only validates
build-validation:  # No publishing

# Release workflow: Only publisher
release:  # Handles all registry publishing
```

### 2. Identical Version and Latest Tags
```yaml
# Build image once
docker build -t ghcr.io/rossigee/PROVIDER:$version

# Tag SAME image as latest
docker tag ghcr.io/rossigee/PROVIDER:$version ghcr.io/rossigee/PROVIDER:latest

# Push both (identical images)
docker push ghcr.io/rossigee/PROVIDER:$version
docker push ghcr.io/rossigee/PROVIDER:latest
```

### 3. Standardized Registry Configuration
- **Primary Registry**: `ghcr.io/rossigee` (all providers)
- **Authentication**: `PAT_TOKEN` secret
- **Namespace**: Matches GitHub repository owner

### 4. Comprehensive Security
- **govulncheck**: Go vulnerability scanning
- **gosec**: Static security analysis  
- **CodeQL**: Advanced security scanning
- **SARIF uploads**: Integrated security reporting

### 5. Optimized Performance
- **Parallel execution**: All validation jobs run in parallel
- **Noop detection**: Skip duplicate actions for efficiency
- **Caching**: Proper Go module and Docker layer caching

## Application Guide

### For New Providers

1. **Copy templates**:
   ```bash
   cp .github-templates/ci-template.yml provider-xxx/.github/workflows/ci.yml
   cp .github-templates/release-template.yml provider-xxx/.github/workflows/release.yml
   ```

2. **Customize for provider**:
   ```bash
   # Replace PROVIDER_NAME with actual name
   sed -i 's/PROVIDER_NAME/provider-xxx/g' provider-xxx/.github/workflows/release.yml
   
   # Update Dockerfile path if needed
   # Default: cluster/images/provider-xxx/Dockerfile
   ```

3. **Test workflows**:
   ```bash
   # Test CI (should only validate, not publish)
   git push origin master
   
   # Test Release (should publish both version and latest identically)  
   git tag v1.0.0
   git push origin v1.0.0
   ```

### For Existing Providers

1. **Review current workflows**: Check for publishing conflicts
2. **Apply templates**: Use the standardized pattern
3. **Test thoroughly**: Ensure no regression in functionality
4. **Monitor**: Verify latest and version tags are identical

## Verification Commands

After applying templates, verify correct behavior:

```bash
# Check that latest and version tags are identical
docker manifest inspect ghcr.io/rossigee/provider-xxx:latest
docker manifest inspect ghcr.io/rossigee/provider-xxx:v1.2.3

# Compare config digests - they should be identical
echo "Latest: $(docker manifest inspect ghcr.io/rossigee/provider-xxx:latest | jq -r '.config.digest')"
echo "Version: $(docker manifest inspect ghcr.io/rossigee/provider-xxx:v1.2.3 | jq -r '.config.digest')"
```

## Build System Requirements

All providers must use the standardized build system:

### Critical Requirements
```yaml
# Build submodule (REQUIRED)
[submodule "build"]
  path = build  
  url = https://github.com/rossigee/build

# Go version (REQUIRED)
GO_VERSION: '1.24.5'

# No custom golangci-lint config (REQUIRED)
# Remove any .golangci.yml files
```

### Initialization
```bash
# After checkout
git submodule update --init --recursive

# Verify build system works
make lint reviewable test
```

## Registry Strategy

### Primary Registry (Always)
- **Location**: `ghcr.io/rossigee`
- **Authentication**: GitHub PAT_TOKEN
- **Tags**: Both version and latest

### Optional Registries (Environment-controlled)
```yaml
# Upbound (optional)
ENABLE_UPBOUND_PUBLISH: true
UPBOUND_TOKEN: ${{ secrets.UPBOUND_TOKEN }}

# Harbor (deprecated - no longer used)
```

## Security Configuration

### Required Secrets
- **`PAT_TOKEN`**: GitHub Container Registry authentication
- **`CODECOV_TOKEN`**: Coverage reporting (optional)
- **`UPBOUND_TOKEN`**: Upbound registry (optional)

### Security Scanning
- **Nightly**: Comprehensive security scans via `security.yml`
- **Per-commit**: gosec and govulncheck in CI
- **SARIF uploads**: Integrated with GitHub Security tab

## Troubleshooting

### Common Issues

#### "Latest and version tags differ"
- **Cause**: Multiple build systems creating different images
- **Fix**: Apply templates to ensure single publishing source

#### "No rule to make target 'lint'"
- **Cause**: Wrong build submodule
- **Fix**: Use `github.com/rossigee/build` submodule

#### "Build validation fails"  
- **Cause**: Missing dependencies or build configuration
- **Fix**: Ensure proper Go version and submodule initialization

### Testing Commands

```bash
# Test build validation (CI workflow)
make build docker.build xpkg.build

# Test publishing (Release workflow)
make publish REGISTRY_ORGS="ghcr.io/rossigee"

# Verify artifacts
ls -la _output/bin/linux_amd64/provider
ls -la _output/xpkg/linux_amd64/*.xpkg
```

## Rollout Status

### Completed ✅
- **provider-mailgun**: Templates applied and tested

### Pending
- Apply templates to remaining 13 providers
- Validate across all providers
- Update any provider-specific customizations

## Support

For issues with these templates:
1. Check build system requirements
2. Verify secret configuration  
3. Test with minimal provider setup
4. Review GitHub Actions logs for specific errors

The templates are designed to be robust and consistent across all providers while maintaining the flexibility for provider-specific requirements.
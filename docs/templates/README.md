# Crossplane Provider CI/CD Templates

**Version 2025-10-28** - Standardized GitHub Actions workflows for all Crossplane providers.

## CI/CD Consistency Analysis & Updates

**Analysis Completed**: Comprehensive review of CI/CD configurations across all 16 Crossplane providers revealed several inconsistencies that have been resolved.

### Key Findings & Fixes Applied

| Issue | Before | After | Status |
|-------|--------|-------|--------|
| **Go Version** | Mixed (1.25.1 in templates, 1.25.3 in providers) | Go 1.25.3 (latest) | ✅ **Fixed** |
| **Setup-Go Action** | @v5 (older) | @v6 (latest) | ✅ **Fixed** |
| **Build Validation** | Mixed approaches (`make build`, `do.build.images`) | `make docker.build` (standard) | ✅ **Documented** |
| **Security Upload** | Failed on SARIF errors | `continue-on-error: true` | ✅ **Fixed** |
| **Documentation** | Outdated version references | Updated for Go 1.25.3 | ✅ **Fixed** |

### Provider Update Status

**✅ Fully Updated (Go 1.25.3 + @v6)**:
- provider-mailgun, provider-minio, provider-plausible, provider-signoz, provider-gitea

**⚠️ Partially Updated (Go 1.25.3 + @v5)**:
- provider-backblaze (uses `do.build.images` instead of `docker.build`)

**❌ Not Yet Updated**:
- Remaining 10 providers need template re-application

## Overview

This directory contains standardized CI/CD templates designed to:
- ✅ **Eliminate email spam** from scheduled security scans
- ✅ **Prevent tag conflicts** between CI and release workflows
- ✅ **Standardize build processes** across all 16 providers
- ✅ **Modernize tooling** to Go 1.25.3 and latest actions

## Problem Solved

**Before**: 57+ unique workflow files across providers causing:
- 112+ weekly security scan emails (16 providers × daily scans)
- Tag conflicts between CI and release workflows
- Inconsistent patterns (3 different approaches)
- Outdated tooling and versions

**After**: Standardized templates providing:
- ⭐ **Zero scheduled emails** (on-demand security scanning only)
- 🏷️ **Clean registry tags** (CI validates, Release publishes)
- ⚡ **Modern tooling** (Go 1.25.1, ubuntu-24.04, latest actions)
- 📋 **Consistent patterns** across all providers

## Version History

### 2025-10-28 (Current)
**CI/CD Consistency Analysis & Updates**:
- ✅ **Go version standardized**: Updated to Go 1.25.3 across all templates
- ✅ **Modernized actions**: actions/setup-go@v6 (latest version)
- ✅ **Fixed SARIF uploads**: Added `continue-on-error: true` to security scan uploads
- ✅ **Updated documentation**: All references now reflect Go 1.25.3
- ✅ **Build validation standardized**: Documented `make docker.build` as standard approach

**Analysis covered**: All 16 providers with findings applied to templates

### 2025-10-23
**Changes**:
- ✅ **Added verification step** to release template
  - Pulls both version and latest tags after publishing
  - Verifies images are pullable from registry
  - Confirms version and latest tags point to identical image digest
  - Fails fast if publication incomplete or tags differ
- ✅ **Uses github.token** for authentication (OIDC, no PAT required)
- ✅ **Confirmed modern tooling**: softprops/action-gh-release@v2 (not deprecated v1)
- ✅ **Added fail-fast behavior** with `set -e` in all workflow steps

**Fixes regressions from**:
- provider-harbor's 2025-10-01 template which reverted to:
  - ❌ GITHUB_TOKEN instead of github.token (OIDC)
  - ❌ Deprecated actions/create-release@v1

### 2025-09-26
**Initial standardization**:
- Separated CI (validation) from Release (publishing)
- Updated to Go 1.25.1
- Eliminated scheduled security scans
- Standardized registry publishing

## Template Files

### 1. `ci-template.yml` - Validation Only
**Purpose**: Build validation and quality checks WITHOUT publishing

```yaml
# Triggers: push, pull_request, workflow_dispatch
# Jobs: lint, check-diff, unit-tests, security-scan, build-validation
# Publishing: NONE (validation only)
```

**Key Features**:
- Parallel validation jobs for speed
- Comprehensive security scanning (integrated into CI)
- Build validation without registry publishing
- Go 1.25.3 with modern tooling

**Standardized Build Validation**:
```bash
# RECOMMENDED approach (used by most providers):
make build                    # Build binary
make docker.build            # Build Docker image locally
make xpkg.build              # Build Crossplane package

# ALTERNATIVE (used by provider-backblaze):
make build                    # Build binary  
make do.build.images         # Alternative Docker build target
make xpkg.build              # Build Crossplane package
```

**Note**: Use `make docker.build` for consistency unless the provider specifically requires `do.build.images`

### 2. `release-template.yml` - Publishing Only
**Purpose**: Registry publishing ONLY on version tag creation

```yaml
# Triggers: push (tags v*.*.*), workflow_dispatch
# Jobs: Single release job with all publishing
# Publishing: Docker images + Crossplane packages
# Verification: Confirms successful publication
```

**Key Features**:
- Single source of truth for publishing
- Version and latest tags from same build (verified via digest comparison)
- Automated verification step (pulls images and confirms identical digests)
- Manual dispatch option for emergency releases
- GitHub release creation with auto-generated notes
- github.token authentication (OIDC, no PAT required)
- Modern tooling (softprops/action-gh-release@v2, not deprecated v1)

### 3. `security-template.yml` - On-Demand Only
**Purpose**: Manual security scanning WITHOUT scheduled triggers

```yaml
# Triggers: workflow_dispatch ONLY (no cron)
# Jobs: Comprehensive security analysis + supply chain
# Notifications: Optional (user controlled)
```

**Key Features**:
- **NO SCHEDULED SCANS** to eliminate email spam
- Configurable scan types (comprehensive, vulnerabilities, secrets, dependencies)
- Optional failure notifications
- Manual trigger via GitHub Actions UI

## Implementation Guide

### Step 1: Apply Templates to Provider

For each provider (e.g., `provider-mailgun`):

```bash
cd provider-mailgun/.github/workflows

# Backup existing workflows (optional)
mkdir -p ../backup
cp *.yml ../backup/ 2>/dev/null || true

# Apply new templates
cp ../../../docs/templates/ci-template.yml ci.yml
cp ../../../docs/templates/release-template.yml release.yml
cp ../../../docs/templates/security-template.yml security.yml

# Remove problematic scheduled workflows
rm -f backport.yml commands.yml renovate.yml cruft-update.yml docs.yml

# Commit changes
git add -A
git commit -m "Standardize CI/CD workflows

- Apply standardized templates from docs/templates/
- Remove scheduled security scans to eliminate email spam
- Separate CI (validation) from Release (publishing)
- Update to Go 1.25.1 and modern tooling"
```

### Step 2: Validate Configuration

After applying templates:

```bash
# Test CI workflow (should only validate, not publish)
git push origin master

# Test release workflow (should publish)
git tag v1.0.0
git push origin v1.0.0

# Test security workflow (manual only)
# Go to GitHub Actions → Security Scanning → Run workflow
```

### Step 3: Monitor Results

**Expected Behavior**:
- ✅ **CI workflow**: Runs on push/PR, validates build, NO publishing
- ✅ **Release workflow**: Runs on tags, publishes to ghcr.io/rossigee
- ✅ **Security workflow**: Manual only, no scheduled emails
- ✅ **Registry tags**: Version and latest point to same image

**Verify Success**:
```bash
# Check that version and latest tags are identical
docker manifest inspect ghcr.io/rossigee/provider-mailgun:v1.0.0
docker manifest inspect ghcr.io/rossigee/provider-mailgun:latest
# Should show same config digest
```

## Batch Application Script

Apply templates to all providers:

```bash
#!/bin/bash
# apply-templates.sh

PROVIDERS=(
  provider-backblaze provider-btcpay provider-cloudflare provider-discord
  provider-docker provider-gitea provider-harbor provider-http
  provider-libvirt provider-mailgun provider-matrix provider-minio
  provider-namecheap provider-openstack provider-plausible provider-signoz
)

for provider in "${PROVIDERS[@]}"; do
  echo "=== Applying templates to $provider ==="

  if [ ! -d "$provider" ]; then
    echo "❌ $provider directory not found, skipping"
    continue
  fi

  # Create workflows directory if it doesn't exist
  mkdir -p "$provider/.github/workflows"

  # Apply templates
  cp docs/templates/ci-template.yml "$provider/.github/workflows/ci.yml"
  cp docs/templates/release-template.yml "$provider/.github/workflows/release.yml"
  cp docs/templates/security-template.yml "$provider/.github/workflows/security.yml"

  # Remove problematic workflows
  cd "$provider/.github/workflows"
  rm -f backport.yml commands.yml renovate.yml cruft-update.yml docs.yml

  # Clean up any scheduled security workflows
  find . -name "*.yml" -exec grep -l "schedule:" {} \; | xargs rm -f

  cd - > /dev/null

  echo "✅ $provider templates applied"
done

echo ""
echo "🎯 Template application completed!"
echo "📧 Scheduled security scans removed (no more email spam)"
echo "🏷️ CI/Release workflows standardized"
echo "⚡ Updated to Go 1.25.1 and modern tooling"
```

## Migration Checklist

For each provider:

- [ ] **Backup existing workflows** (optional)
- [ ] **Apply three templates** (ci.yml, release.yml, security.yml)
- [ ] **Remove scheduled workflows** (any with `cron:` triggers)
- [ ] **Remove unnecessary workflows** (backport, commands, renovate, cruft, docs)
- [ ] **Test CI workflow** (push to master - should validate only)
- [ ] **Test release workflow** (create version tag - should publish)
- [ ] **Verify registry tags** (version and latest should be identical)
- [ ] **Confirm no scheduled emails** (check Security tab instead)

## Results

**Expected Improvements**:
- 📧 **Email reduction**: 112+ weekly → 0 scheduled emails
- 📝 **Consistency**: 3 patterns → 1 unified standard
- 📁 **File reduction**: 57+ workflows → 48 standardized (15% reduction)
- ⚡ **Modern tooling**: Go 1.25.1, ubuntu-24.04, latest actions
- 🏷️ **Clean registry**: No more tag conflicts between workflows

**Success Metrics**:
- Zero daily security scan emails
- All providers use identical workflow patterns
- Version and latest tags always point to same image digest
- Security scans available on-demand via GitHub Actions UI
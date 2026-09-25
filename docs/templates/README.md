# Crossplane Provider CI/CD Templates

**Version 2026-09-24** - Standardized GitHub Actions workflows + release standards for all Crossplane providers.
Part of the [standards](../content/standards/_index.md); platform floor (Crossplane
`>= v2.5`): [platform.md](../content/standards/platform.md).

The release-preparation branches use:
- Go 1.27.1
- golangci-lint 2.13.2 with .golangci.yml (gofmt + goimports + core linters)
- pre-commit v6.0.0 + hadolint v2.12.0 (excludes `tools/` and `*_test.go` where appropriate)
- Full security scanning (govulncheck + gosec SARIF upload) in CI + security.yml
- Consistent rossigee/build makelib for `make lint` etc. (`rossigee-lint-fixes @ e5bf20a`, runtime v2.5.0)

## CI/CD Consistency Analysis & Updates

**Analysis Completed**: Comprehensive review of CI/CD configurations across all 20 Crossplane providers revealed several inconsistencies that have been resolved.

### Key Findings & Fixes Applied

| Issue | Before | After | Status |
|-------|--------|-------|--------|
| **Go Version** | Mixed / outdated | Go 1.27.1 + GO_REQUIRED_VERSION in Makefiles | ✅ **Fixed** (2026-09-08) |
| **Lint Config** | None or per-repo | Identical .golangci.yml (v2, golangci-lint 2.13.2) in all + templates | ✅ **Fixed** |
| **CI Structure** | Inconsistent (some missing security-scan) | Standardized template + full gosec/govuln/SARIF in ci.yml | ✅ **Fixed** (outliers migrated) |
| **Actions** | Mixed v4/v5 | checkout@v7 + setup-go@v7 | ✅ **Fixed** |
| **Templates** | Stale / outdated comments | Updated + .golangci.yml added | ✅ **Fixed** |
| **pre-commit / hadolint** | Mixed / missing excludes | pre-commit v6.0.0 + hadolint v2.12.0 with `tools/` and `*_test.go` excludes | ✅ **Fixed** (2026-09-08) |

### Provider Update Status

Release preparation for all 20 providers is aligned as of 2026-09-24:
- .golangci.yml present and identical in all (golangci-lint 2.13.2)
- ci.yml follows standardized template (with security-scan job) — `GO_VERSION: '1.27.1'`
- GO 1.27.1 everywhere in workflows + Makefiles + go.mod (verified via `scripts/audit_standards.sh`)
- pre-commit v6.0.0 + hadolint v2.12.0 with `tools/` and `*_test.go` excludes standardized
- Outliers (hostinger, minio, btcpay) migrated to full template

Special providers retain documented customizations (extra workflows, CGO, or native packaging).

### Allowed template drift

`scripts/audit_workflows.sh` flags >5 unified-diff lines vs the templates.
Intentional (not defects) — full list in that script’s header:

* **ci.yml**: system deps (`libvirt-dev`), `needs:` graphs, extra tokens, codecov `files:`
* **release.yml**: historical change-note comments, provider verification lines
* **security.yml**: CodeQL/schedule knobs (GO_VERSION must still match the pin)
* **auto-merge.yml**: must match the template byte-for-byte

## Overview

This directory contains standardized CI/CD templates designed to:
- ✅ **Eliminate email spam** from scheduled security scans
- ✅ **Prevent tag conflicts** between CI and release workflows
- ✅ **Standardize build processes** across all 20 providers
- ✅ **Modernize tooling** to Go 1.27.1 and latest actions (golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)

## Problem Solved

**Before**: 57+ unique workflow files across providers causing:
- 112+ weekly security scan emails (20 providers × daily scans)
- Tag conflicts between CI and release workflows
- Inconsistent patterns (3 different approaches)
- Outdated tooling and versions

**After**: Standardized templates providing:
- ⭐ **Zero scheduled emails** (on-demand security scanning only)
- 🏷️ **Clean registry tags** (CI validates, Release publishes)
- ⚡ **Modern tooling** (Go 1.27.1, ubuntu-24.04, checkout@v7, setup-go@v7, golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)
- 📋 **Consistent patterns** across all 20 providers + .golangci.yml lint config
- 🧹 **Clean excludes** (`tools/` and `*_test.go` excluded from go-fmt/go-imports/go-vet where needed)

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
- Go 1.27.1 with modern tooling (golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)

**Standardized Build Validation**:
```bash
# Standard approach (all providers; `make build` builds the image via
# build.artifacts.platform — the nonexistent `make docker.build` was removed
# 2026-09-23):
make build                    # Build binary + Docker image locally
make xpkg.build               # Build Crossplane package
```

### 2. `release-template.yml` - Publishing Only
**Purpose**: Registry and GitHub publishing only on version tag creation

```yaml
# Triggers: push (tags v*.*.*)
# Source: tag must equal current origin/master
# Publishing: versioned xpkg plus latest digest alias
# Verification: equal digests and linux/amd64 + linux/arm64 manifests
```

**Key Features**:
- Tag-only publishing from the exact green `master` commit
- Exact `vMAJOR.MINOR.PATCH` validation
- QEMU-backed `linux_amd64` and `linux_arm64` builds
- Version and `latest` aliases verified by digest equality
- GHCR authentication with the repository `github.token`
- GitHub release creation with auto-generated notes

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

### 4. `dependabot.yml` - Dependency Updates
**Purpose**: Automated dependency monitoring and PR creation

```yaml
# Monitors: Go modules, GitHub Actions, Dockerfiles
# Schedule: Weekly (Friday 10:00 UTC)
# Auto-merge: Handled by auto-merge.yml workflow
```

**Key Features**:
- Three ecosystems: `gomod`, `github-actions`, `docker`
- Grouped updates to reduce PR noise (minor/patch)
- Standardized schedule: Friday 10:00 UTC across all providers
- Works with `auto-merge.yml` for severity-based auto-merge

**Auto-Merge Policy** (governed by `auto-merge.yml`):

| Label | Action |
|-------|--------|
| `dependencies/go/minor` | Auto-merge |
| `dependencies/go/patch` | Auto-merge |
| `dependencies/github-actions/minor` | Auto-merge |
| `dependencies/github-actions/patch` | Auto-merge |
| `dependencies/docker/minor` | Auto-merge |
| `dependencies/docker/patch` | Auto-merge |
| `dependencies/security` | Block (human review) |
| `dependencies/go/major` | Block (human review) |
| *(unlabeled)* | Block (human review) |

CI's `govulncheck` + `gosec` must pass before auto-merge proceeds.

### 5. `auto-merge.yml` - Severity-Based Auto-Merge
**Purpose**: Automatically merge low-risk Dependabot PRs after CI passes

```yaml
# Triggers: pull_request_target (opened, synchronize, labeled)
# Actor: Only runs for dependabot[bot]
# Requires: All CI checks pass (lint, check-diff, unit-tests, security-scan)
```

**Key Features**:
- Only triggers for Dependabot PRs (`github.actor == 'dependabot[bot]'`)
- Waits for CI checks to complete (with retry)
- Squash-merges eligible PRs, deletes branch
- Blocks security, major, and unclassified updates
- No additional labels required — works with Dependabot's native labels

**Merge Conditions**:
1. PR is from Dependabot
2. Update is minor or patch (Go, GitHub Actions, or Docker)
3. Update is NOT a security fix
4. All required CI checks pass
5. PR is mergeable (no conflicts)

## Implementation Guide

### Step 1: Apply Templates to Provider

For each provider (e.g., `provider-mailgun`):

```bash
cd provider-mailgun

# Open a review branch; do not push provider changes directly to master
git switch -c chore/standardize-release-process

# Apply new templates
cp ../../docs/templates/ci-template.yml .github/workflows/ci.yml
cp ../../docs/templates/release-template.yml .github/workflows/release.yml
cp ../../docs/templates/security-template.yml .github/workflows/security.yml

# Remove problematic scheduled workflows
rm -f .github/workflows/backport.yml .github/workflows/commands.yml .github/workflows/renovate.yml .github/workflows/cruft-update.yml .github/workflows/docs.yml

# Commit changes
git add -A
git commit -m "Standardize CI/CD workflows

- Apply standardized templates from docs/templates/
- Remove scheduled security scans to eliminate email spam
- Separate CI (validation) from Release (publishing)
- Update to Go 1.27.1 and modern tooling (golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)"

git push -u origin chore/standardize-release-process
gh pr create --base master --head chore/standardize-release-process
```

### Step 2: Validate Configuration

After applying templates:

```bash
# Open a PR and wait for review/CI before tagging
# Test release workflow only from the merged, green master commit
git tag -a v1.0.0 -m "Release v1.0.0" HEAD
git push origin v1.0.0

# Test security workflow (manual only)
# Go to GitHub Actions → Security Scanning → Run workflow
```

### Step 3: Monitor Results

**Expected Behavior**:
- ✅ **CI workflow**: Runs on push/PR, validates build, NO publishing
- ✅ **Release workflow**: Runs on exact `vMAJOR.MINOR.PATCH` tags and publishes the xpkg to GHCR
- ✅ **Registry tags**: Version and `latest` resolve to the same OCI index
- ✅ **Platforms**: The index contains `linux/amd64` and `linux/arm64`

**Verify Success**:
```bash
docker buildx imagetools inspect ghcr.io/rossigee/provider-mailgun:v1.0.0 --format '{{.Manifest.Digest}}'
docker buildx imagetools inspect ghcr.io/rossigee/provider-mailgun:latest --format '{{.Manifest.Digest}}'
```

## Batch Application Script

Apply templates to all providers:

```bash
#!/bin/bash
# apply-templates.sh

PROVIDERS=(
  provider-backblaze provider-btcpay provider-cloudflare provider-discord
  provider-docker provider-gitea provider-harbor provider-hostinger provider-http
  provider-keycloak provider-libvirt provider-mailgun provider-matrix provider-minio
  provider-namecheap provider-openstack provider-plausible provider-rabbitmq
  provider-signoz provider-vault
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
  cp docs/templates/auto-merge.yml "$provider/.github/workflows/auto-merge.yml"
  cp docs/templates/dependabot.yml "$provider/.github/dependabot.yml"

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
echo "⚡ Updated to Go 1.27.1 and modern tooling (golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)"
```

## Migration Checklist

For each provider:

- [ ] **Backup existing workflows** (optional)
- [ ] **Apply three templates** (ci.yml, release.yml, security.yml)
- [ ] **Apply QA assistance templates** (dependabot.yml, auto-merge.yml)
- [ ] **Remove scheduled workflows** (any with `cron:` triggers)
- [ ] **Remove unnecessary workflows** (backport, commands, renovate, cruft, docs)
- [ ] **Configure branch protection** (require CI checks, allow Dependabot auto-merge)
- [ ] **Test CI workflow** (push to master - should validate only)
- [ ] **Test release workflow** (create version tag - should publish)
- [ ] **Verify registry tags** (version and latest should be identical)
- [ ] **Confirm no scheduled emails** (check Security tab instead)

## Results

**Expected Improvements**:
- 📧 **Email reduction**: 112+ weekly → 0 scheduled emails
- 📝 **Consistency**: 3 patterns → 1 unified standard
- 📁 **File reduction**: 57+ workflows → 48 standardized (15% reduction)
- ⚡ **Modern tooling**: Go 1.27.1, ubuntu-24.04, latest actions (golangci-lint 2.13.2, pre-commit v6.0.0, hadolint v2.12.0)
- 🏷️ **Clean registry**: No more tag conflicts between workflows
- 🤖 **Automated dependency updates**: Dependabot creates PRs weekly on Fridays
- 🔀 **Auto-merge for safe updates**: Minor/patch Go, Actions, Docker updates merge automatically after CI passes
- ⛔ **Security gates intact**: Security and major updates always require human review

**Success Metrics**:
- Zero daily security scan emails
- All providers use identical workflow patterns
- Version and latest tags always point to same image digest
- Minor/patch Dependabot PRs auto-merge after passing CI
- Security/major Dependabot PRs blocked and require human review
- Security scans available on-demand via GitHub Actions UI
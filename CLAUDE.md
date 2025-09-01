# Crossplane Providers Repository

## Overview
This repository contains a collection of Crossplane providers for managing external infrastructure and services through Kubernetes. Each provider enables declarative, GitOps-style management of specific platforms.

## Active Providers - **ALL PROVIDERS STANDARDIZED (2025-07-24)**

### ✅ **CI/CD & Registry Standardization Complete**

**All 14 providers now have:**
- ✅ **Standardized CI/CD**: GitHub Actions workflows with consistent patterns
- ✅ **Primary Registry**: `ghcr.io/rossigee` (default for all providers)
- ✅ **Optional Registries**: Harbor and Upbound configurable via environment variables
- ✅ **Master Branch**: All providers on consistent `master` branch
- ✅ **Fresh Releases**: New minor version tags created for container deployment
- ✅ **Tag Conflict Resolution**: "CI Builds, Release Publishes" pattern eliminates image differences (2025-08-14)

### Production Ready
- **provider-plausible** (v1.2.0) - Plausible Analytics sites and goals management
  - Registry: `ghcr.io/rossigee/provider-plausible:v1.2.0`
  - Previous: `ghcr.io/crossplane-contrib/provider-plausible:v0.1.0`

### In Development  
- **provider-btcpay** (v0.3.0) - BTCPay Server management (stores, invoices, webhooks)
  - Registry: `ghcr.io/rossigee/provider-btcpay:v0.3.0`
- **provider-signoz** (v0.3.0) - SigNoz observability platform management
  - Registry: `ghcr.io/rossigee/provider-signoz:v0.3.0`
- **provider-libvirt** (v0.2.0) - KVM/libvirt virtual machine provisioning
  - Registry: `ghcr.io/rossigee/provider-libvirt:v0.2.0`

### Standard Providers
- **provider-minio** (v0.6.0) - MinIO object storage (buckets, users, policies)
  - Registry: `ghcr.io/rossigee/provider-minio:v0.6.0`
- **provider-harbor** (v0.4.0) - Harbor container registry management
  - Registry: `ghcr.io/rossigee/provider-harbor:v0.4.0`
  - **✅ FIXED**: Registry conflicts resolved with standardization
- **provider-http** (v1.2.0) - Generic HTTP request resources
  - Registry: `ghcr.io/rossigee/provider-http:v1.2.0`
- **provider-vault** (v2.4.0) - HashiCorp Vault secrets management
  - Registry: `ghcr.io/rossigee/provider-vault:v2.4.0`
- **provider-openstack** (v0.10.0) - OpenStack cloud resources
  - Registry: `ghcr.io/rossigee/provider-openstack:v0.10.0`

### Additional Providers
- **provider-discord** (v0.3.0) - Discord server management
  - Registry: `ghcr.io/rossigee/provider-discord:v0.3.0`
- **provider-gitea** (v0.3.0) - Gitea repository management
  - Registry: `ghcr.io/rossigee/provider-gitea:v0.3.0`
- **provider-matrix** (v0.2.0) - Matrix chat server management
  - Registry: `ghcr.io/rossigee/provider-matrix:v0.2.0`
- **provider-mailgun** (v0.6.0) - Mailgun email service management
  - Registry: `ghcr.io/rossigee/provider-mailgun:v0.6.0`
- **provider-backblaze** (v0.2.0) - Backblaze B2 cloud storage
  - Registry: `ghcr.io/rossigee/provider-backblaze:v0.2.0`
- **provider-cloudflare** (v0.2.0) - Cloudflare DNS and security services
  - Registry: `ghcr.io/rossigee/provider-cloudflare:v0.2.0`
- **provider-gitea-native** (v0.2.0) - Gitea repository management (native implementation)
  - Registry: `ghcr.io/rossigee/provider-gitea-native:v0.2.0`
- **provider-docker** (v0.2.0) - Docker container and image management
  - Registry: `ghcr.io/rossigee/provider-docker:v0.2.0`

## Common Structure
```
provider-xxx/
├── apis/              # API definitions and CRD types
├── cmd/provider/      # Main entry point
├── config/            # Provider configuration and setup
├── examples/          # Usage examples and sample manifests
├── internal/          # Controllers and API clients
├── package/           # Crossplane packaging and CRDs
└── Makefile          # Build orchestration
```

## Build Commands
```bash
# Essential make targets (now working across all providers)
make lint            # Lint code with golangci-lint
make reviewable      # Full pre-commit check (generate, lint, test)
make test           # Run unit tests with coverage
make generate       # Generate code and CRDs
make build          # Build the provider binary
make docker-build   # Build container image
make xpkg.build     # Build Crossplane package
make clean          # Clean build artifacts
```

## Standardized Build Requirements ✅

### **Prerequisites**
- **Go 1.24+**: Required for all providers
- **Docker**: For container image builds
- **Make**: Build orchestration
- **Git Submodules**: Essential for build system

### **Critical Build System Components**
1. **Build Submodule**: All providers MUST use `github.com/rossigee/build`
   ```yaml
   # .gitmodules (REQUIRED)
   [submodule "build"]
     path = build  
     url = https://github.com/rossigee/build
   ```

2. **Submodule Initialization**: Required after checkout
   ```bash
   git submodule update --init --recursive
   ```

3. **No Custom golangci-lint Config**: Use build submodule defaults
   - Remove any `.golangci.yml` files that cause version conflicts
   - Build submodule provides compatible configuration

4. **Go Version Compatibility**: Ensure Makefile settings match regex parsing
   ```makefile
   # Use 1.24 not 1.24.5 due to version parsing
   GO_REQUIRED_VERSION ?= 1.24
   ```

### **Validation Commands**
```bash
# Verify build system works
make lint            # Should complete without "No rule to make target" errors
make reviewable      # Full validation pipeline
make test           # Unit test execution
```

### **Common Issues & Solutions**
- **"No rule to make target 'lint'"**: Wrong build submodule (use rossigee/build)
- **"unsupported version of configuration"**: Remove .golangci.yml file
- **"go version X.Y is not supported"**: Fix GO_REQUIRED_VERSION in Makefile
- **"go mod tidy needed"**: Run `go mod tidy` to update dependencies

## Key Patterns
1. **API Versioning**: v1alpha1 for resources, v1beta1 for provider configs
2. **Controller Pattern**: Each resource type has dedicated controller
3. **Code Generation**: Extensive use for CRDs and boilerplate
4. **Client Isolation**: External APIs wrapped in internal/clients
5. **Crossplane Runtime**: Full managed resource lifecycle integration

## Build System Standardization ✅ (2025-08-04)

### **Critical Build System Fix Complete**
All providers now use the **rossigee/build** fork instead of the broken upstream **crossplane/build**:

- ✅ **Root Cause Resolved**: Updated `.gitmodules` in all 6 affected providers
- ✅ **Make Targets Working**: `lint`, `reviewable`, `test`, `clean`, `generate` all functional
- ✅ **CI/CD Ready**: GitHub Actions workflows now pass without "No rule to make target" errors

### **Providers Updated (2025-08-04)**
- **provider-gitea**: Build submodule updated → CI/CD fixed
- **provider-signoz**: Build submodule + HTTP client lint fixes
- **provider-openstack**: Build submodule + golangci config removal + import fixes  
- **provider-http**: Build submodule + golangci config removal + partial lint fixes
- **provider-vault**: Build submodule + Go version fix + module updates

### **Technical Details**
- **Problem**: `github.com/crossplane/build` missing essential make targets
- **Solution**: All providers now use `github.com/rossigee/build` (working fork)
- **Side Fixes**: Removed incompatible golangci-lint configs, fixed Go version parsing, updated modules
- **Verification**: `make reviewable` tested successfully on updated providers

## Development Status  
- Repository cleaned and standardized (2025-07-27)
- **Build system standardized and fixed (2025-08-04)**
- Build artifacts and archived versions removed
- Consistent structure across all providers
- **All providers use rossigee/build submodule (FIXED)**
- Custom build scripts (build-and-push.sh) in active development providers
- Package artifacts (.xpkg) maintained only in package/ directories

## CI/CD Workflow Standardization ✅ (2025-08-14)

### **Tag Conflict Resolution Complete**

**Problem Identified**: CI and Release workflows were both publishing images, causing `latest` and version tags to point to different images.

**Solution Implemented**: "CI Builds, Release Publishes" pattern:
- **CI Workflow**: Build validation only (no registry publishing)
- **Release Workflow**: Single source of truth for all publishing
- **Result**: Version and `latest` tags always point to identical images

### **Standardized Templates Created**

**Location**: `.github-templates/`
- **`ci-template.yml`**: Standardized CI workflow (validation only)
- **`release-template.yml`**: Standardized release workflow (publishing only)
- **`README.md`**: Complete implementation guide

**Key Features**:
- **Parallel validation**: lint, check-diff, unit-tests, security-scan
- **Noop detection**: Skip duplicate actions for efficiency
- **Comprehensive security**: govulncheck, gosec, CodeQL integration
- **Single registry publishing**: Eliminates conflicts

### **Applied and Tested**
- ✅ **provider-mailgun**: Templates applied, tag conflicts resolved
- 📋 **Remaining providers**: Ready for template rollout

### **Verification Commands**
```bash
# Verify identical tags (should show same config digest)
docker manifest inspect ghcr.io/rossigee/provider-xxx:latest
docker manifest inspect ghcr.io/rossigee/provider-xxx:v1.2.3
```

## Repository Cleanup Complete ✅
- **Archived Providers**: Removed `00-archive/` directory with old provider-libvirt-nourspeed and provider-mailgun.bak
- **Build Artifacts**: Cleaned all `_output/`, `bin/`, coverage files, and test binaries  
- **Package Files**: Removed orphaned .xpkg files, kept only official packages in `package/` directories
- **Structure**: Standardized directory layout and removed temporary files
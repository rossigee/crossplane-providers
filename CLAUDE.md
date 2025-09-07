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
- **provider-minio** (v0.16.5) - MinIO object storage (buckets, users, policies)
  - Registry: `ghcr.io/rossigee/provider-minio:v0.16.5`
  - **✅ FIXED**: Container startup issues resolved (2025-09-06)
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
make build          # Build the provider binary and local Docker image
make publish         # Build, package, and publish to registry (RECOMMENDED)
make xpkg.build     # Build Crossplane package with embedded runtime
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
- **"no command specified" container errors**: Missing package/crossplane.yaml file (see Critical Package Structure below)

## ⚠️ CRITICAL: Working Provider Build Process ⚠️

### **Essential Requirements for Functional Providers**

**MANDATORY Package Structure:**
```
provider-xxx/
├── package/
│   ├── crossplane.yaml     # REQUIRED - NOT package.yaml!
│   ├── crds/              # Generated CRDs
│   └── webhook/           # Webhook certificates (if applicable)
├── cluster/images/provider-xxx/
│   └── Dockerfile         # MUST use ENTRYPOINT, not CMD
├── cmd/provider/
│   └── main.go           # Environment variable configuration
└── build/                # rossigee/build submodule
```

### **Critical Build System Integration**

**1. Package Metadata File Naming:**
- ✅ **CORRECT**: `package/crossplane.yaml` 
- ❌ **WRONG**: `package/package.yaml`
- **Why**: Build system's `--embed-runtime-image` logic searches for `crossplane.yaml`
- **Without this**: Docker images are NOT embedded, causing "no command specified" errors

**2. Dockerfile ENTRYPOINT Requirements:**
- ✅ **CORRECT**: `ENTRYPOINT ["/usr/local/bin/provider"]`
- ❌ **WRONG**: `CMD ["/usr/local/bin/provider", "--leader-elect"]`
- **Why**: Crossplane expects providers to handle arguments via environment variables
- **Example from working provider:**
```dockerfile
FROM gcr.io/distroless/static:nonroot
COPY --chmod=0755 bin/linux_amd64/provider /usr/local/bin/provider
ENTRYPOINT ["/usr/local/bin/provider"]
```

**3. Environment Variable Configuration (cmd/provider/main.go):**
- ✅ **CORRECT**: `CertDir: os.Getenv("WEBHOOK_TLS_CERT_DIR")`
- ❌ **WRONG**: `CertDir: "/tmp/k8s-webhook-server/serving-certs"`
- **Why**: Crossplane mounts certificates at runtime-determined paths
- **Key Variables**: `WEBHOOK_TLS_CERT_DIR`, `TLS_SERVER_CERTS_DIR`, `LEADER_ELECT`

### **Correct Build Sequence**

**Prerequisites:**
```bash
# MANDATORY - Initialize build submodule
git submodule update --init --recursive

# Verify build system works
make lint                   # Should complete without errors
```

**Working Build Process:**
```bash
# 1. Generate CRDs and prepare
make generate              # Generate CRDs based on Go types

# 2. Build and publish everything (replaces individual build steps)
make publish VERSION=vX.Y.Z PLATFORMS=linux_amd64    # Single command for complete build and push

# Alternative: For multi-platform builds (if cross-compilation works)
make publish VERSION=vX.Y.Z PLATFORMS="linux_amd64 linux_arm64"

# 3. Verify package was published
# Check registry for both Docker image and Crossplane package at same tag
```

**Verification Commands:**
```bash
# Check Docker image has correct ENTRYPOINT
docker inspect BUILD_REGISTRY/provider-xxx-amd64 | jq -r '.[0].Config.Entrypoint, .[0].Config.Cmd'
# Should show: ["/usr/local/bin/provider"] and null

# Extract and verify .xpkg package
tar -tf _output/xpkg/linux_amd64/provider-xxx-vX.Y.Z.xpkg | grep -E "(manifest.json|sha256:)"
# Should contain Docker image layers and manifest
```

### **Common Build Failures & Fixes**

**Issue**: "grep: package/crossplane.yaml: No such file or directory"
- **Cause**: File named `package.yaml` instead of `crossplane.yaml`
- **Fix**: `mv package/package.yaml package/crossplane.yaml`

**Issue**: "no command specified" when provider starts
- **Cause**: Dockerfile uses CMD instead of ENTRYPOINT
- **Fix**: Change `CMD ["/usr/local/bin/provider", "--args"]` to `ENTRYPOINT ["/usr/local/bin/provider"]`

**Issue**: TLS certificate mounting failures  
- **Cause**: Hardcoded certificate paths in main.go
- **Fix**: Use `os.Getenv("WEBHOOK_TLS_CERT_DIR")` instead of hardcoded paths

**Issue**: Make targets not found
- **Cause**: Wrong build submodule (using crossplane/build instead of rossigee/build)
- **Fix**: Update `.gitmodules` to use `https://github.com/rossigee/build`

### **Build System Architecture**

**How `--embed-runtime-image` Works:**
```makefile
# From build/makelib/xpkg.mk
embed_runtime_arg=$(grep -E '^kind:\s+Provider\s*$' $(XPKG_DIR)/crossplane.yaml > /dev/null && echo "--embed-runtime-image $(BUILD_REGISTRY)/$(1)-$(ARCH)")
```

1. **Searches for**: `package/crossplane.yaml` with `kind: Provider`
2. **If found**: Adds `--embed-runtime-image BUILD_REGISTRY/provider-xxx-amd64` to crossplane CLI
3. **Result**: Docker image is embedded into .xpkg package for runtime use
4. **If missing**: Package is built WITHOUT Docker image → "no command specified" errors

### **Registry and Deployment**

**Package Publishing:**
```bash
# Push to registry (package includes embedded Docker image)
crossplane xpkg push -f _output/xpkg/linux_amd64/provider-xxx-vX.Y.Z.xpkg ghcr.io/rossigee/provider-xxx:vX.Y.Z

# Deploy to cluster
kubectl --kubeconfig ~/.kube/CLUSTER-admin.conf patch provider provider-xxx \
  --type='merge' -p='{"spec":{"package":"ghcr.io/rossigee/provider-xxx:vX.Y.Z"}}'
```

## Crossplane Provider Architecture: v1 vs v2

### **Crossplane v1 Provider Architecture (Legacy)**

**Core Characteristics:**
- **Cluster-Scoped Resources**: All managed resources are cluster-scoped with no namespace isolation
- **Infrastructure-Only**: Compositions limited to infrastructure resources (no general Kubernetes resources)
- **Single Provider Bundles**: Installing a provider (e.g., AWS) installs all 100+ resource types at once
- **Claims Pattern**: Complex claim/composite resource (XR) relationship with cluster scope
- **ControllerConfig**: Uses ControllerConfig type for runtime configuration
- **Default Registry Support**: Supports `--registry` flag for default registry configuration

**Build Structure (v1):**
```
provider-xxx/
├── apis/                    # API definitions (cluster-scoped CRDs)
│   └── v1alpha1/           # API version (typically v1alpha1 or v1beta1)
├── cmd/provider/           # Provider entry point
├── config/                 # Provider configuration
│   ├── provider/           # Provider metadata
│   └── crd/               # Generated CRDs (cluster-scoped)
├── internal/
│   └── controller/        # Controllers for managed resources
├── package/               # Crossplane package (.xpkg)
└── examples/              # Usage examples
```

**Build Process (v1):**
```bash
make generate          # Generate cluster-scoped CRDs
make build            # Build provider binary
make docker-build     # Build container image
make xpkg.build       # Build .xpkg package
```

**Resource Format (v1):**
```yaml
apiVersion: s3.aws.crossplane.io/v1beta1  # No .m. in API group
kind: Bucket
metadata:
  name: my-bucket  # Cluster-scoped, no namespace
```

### **Crossplane v2 Provider Architecture (Current)**

**Core Characteristics:**
- **Dual-Scope Support**: Supports both namespaced and cluster-scoped managed resources
- **Namespaced by Default**: New resources are namespaced with `.m.` in API group (e.g., `s3.aws.m.upbound.io`)
- **Universal Compositions**: Compositions can include ANY Kubernetes resource, not just infrastructure
- **Managed Resource Definitions (MRDs)**: Selective activation of provider resources using activation policies
- **DeploymentRuntimeConfig**: Replaces ControllerConfig for runtime configuration
- **Fully Qualified Images**: Mandatory fully qualified image names (no default registry support)

**Build Structure (v2):**
```
provider-xxx/
├── apis/                    # API definitions (dual-scope support)
│   ├── v1alpha1/           # Legacy cluster-scoped APIs
│   └── v1beta1/           # Namespaced APIs with .m. group
├── cmd/provider/           # Provider entry point
├── config/                 # Enhanced provider configuration
│   ├── provider/           # Provider metadata
│   ├── crd/               # Generated CRDs (both scoped types)
│   └── mrd/               # Managed Resource Definitions
├── internal/
│   ├── controller/        # Controllers for both scoped resources
│   └── clients/           # External API clients
├── package/               # Crossplane package (.xpkg) with MRDs
└── examples/              # Usage examples for both scopes
```

**Build Process (v2):**
```bash
make generate          # Generate both cluster-scoped and namespaced CRDs + MRDs
make build            # Build provider binary with dual-scope support
make docker-build     # Build container image
make xpkg.build       # Build .xpkg package with MRDs
make lint             # Enhanced linting for v2 compliance
make reviewable       # Full validation including v2 compatibility
```

**Resource Format (v2 Namespaced):**
```yaml
apiVersion: s3.aws.m.upbound.io/v1beta1  # Note .m. in API group
kind: Bucket
metadata:
  name: my-bucket
  namespace: production      # Namespaced resource
```

**Resource Format (v2 Legacy Support):**
```yaml
apiVersion: s3.aws.crossplane.io/v1beta1  # Legacy cluster-scoped still supported
kind: Bucket
metadata:
  name: my-bucket  # No namespace (cluster-scoped)
```

### **Migration Considerations**

**Backward Compatibility:**
- ✅ **Existing v1 resources continue to work unchanged**
- ✅ **No breaking changes for cluster-scoped resources**
- ✅ **Gradual migration supported**
- ⚠️ **No automated migration tooling available**

## ✅ v2 Migration Status - COMPLETED (2025-09-06)

Both **provider-minio** and **provider-mailgun** have been successfully migrated to support Crossplane v2 patterns with full dual-scope compatibility:

### ✅ provider-minio v2 Migration Complete
- **Dual API Support**: Both `minio.crossplane.io/v1` (cluster-scoped) and `minio.m.crossplane.io/v1beta1` (namespaced) APIs
- **Resources Migrated**: Bucket, User, Policy, ServiceAccount (4 resources)  
- **Build Status**: All tests pass, successful compilation and packaging
- **Examples**: v1beta1 examples created and validated

### ✅ provider-mailgun v2 Migration Complete  
- **Dual API Support**: Both `mailgun.crossplane.io/v1alpha1` (cluster-scoped) and `mailgun.m.crossplane.io/v1beta1` (namespaced) APIs
- **Resources Migrated**: Domain, MailingList, Route, Webhook, Template, SMTPCredential, Bounce (7 resources)
- **Build Status**: All 133+ tests pass, successful compilation and packaging
- **Examples**: v1beta1 examples created and validated

**Provider Development Changes:**
- **Fully Qualified Images**: Must specify complete registry paths
- **MRD Support**: Providers should include Managed Resource Definitions
- **Dual Controllers**: Controllers must handle both scoped and namespaced resources
- **API Versioning**: Namespaced resources often reset API versions (e.g., v1beta2 → v1beta1)

**Upgrade Path:**
1. Upgrade from Crossplane v1.20+ only
2. Update provider manifests to v2 versions
3. Ensure all package references use fully qualified image names
4. Optionally configure Managed Resource Activation Policies (MRAPs)
5. Test both namespaced and cluster-scoped resource creation

### **Current Repository Status**

**Provider Classification:**
- **Legacy v1 Style**: Most providers in this repository follow v1 patterns (cluster-scoped)
- **v2 Compatible**: All providers support v2 runtime but may not fully implement namespaced resources
- **Build System**: Standardized v1/v2 compatible build system using rossigee/build submodule
- **Registry**: All use fully qualified registry names (`ghcr.io/rossigee/provider-xxx`)

**Migration Priority:**
- 🟡 **Medium Priority**: Consider migrating to full v2 patterns for new resources
- 🔵 **Backward Compatible**: Existing cluster-scoped resources remain fully supported
- ⚪ **Future Planning**: Namespaced resources provide better multi-tenancy and isolation

## Key Patterns
1. **API Versioning**: v1alpha1 for resources, v1beta1 for provider configs
2. **Controller Pattern**: Each resource type has dedicated controller
3. **Code Generation**: Extensive use for CRDs and boilerplate
4. **Client Isolation**: External APIs wrapped in internal/clients
5. **Crossplane Runtime**: Full managed resource lifecycle integration
6. **Dual-Scope Support**: v2 providers support both namespaced and cluster-scoped resources

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

## Usage Guide: v1 vs v2 APIs

### Using v1 APIs (Cluster-Scoped - Legacy)

```yaml
# provider-minio v1 (cluster-scoped)
apiVersion: minio.crossplane.io/v1
kind: Bucket
metadata:
  name: example-bucket-v1  # No namespace
spec:
  forProvider:
    bucketName: my-bucket-cluster-scoped
    region: us-east-1
  providerConfigRef:
    name: default
  deletionPolicy: Delete
---
# provider-mailgun v1alpha1 (cluster-scoped)
apiVersion: domain.mailgun.crossplane.io/v1alpha1
kind: Domain  
metadata:
  name: example-domain-v1  # No namespace
spec:
  forProvider:
    name: example-v1.com
    type: sending
  providerConfigRef:
    name: default
  deletionPolicy: Delete
```

### Using v2 APIs (Namespaced - Recommended)

```yaml
# provider-minio v1beta1 (namespaced)
apiVersion: minio.m.crossplane.io/v1beta1
kind: Bucket
metadata:
  name: example-bucket-v2
  namespace: my-tenant  # Namespace isolation
spec:
  forProvider:
    bucketName: my-bucket-namespaced
    region: us-east-1
  providerConfigRef:
    name: default
  deletionPolicy: Delete
---
# provider-mailgun v1beta1 (namespaced)
apiVersion: domain.mailgun.m.crossplane.io/v1beta1
kind: Domain
metadata:
  name: example-domain-v2
  namespace: my-tenant  # Namespace isolation
spec:
  forProvider:
    name: example-v2.com  
    type: sending
  providerConfigRef:
    name: default
  deletionPolicy: Delete
```

### Migration Best Practices

1. **Start with v2 APIs** for new resources to benefit from namespace isolation
2. **Gradual Migration** - existing v1 resources continue working
3. **Namespace Strategy** - use meaningful namespaces for tenant isolation
4. **RBAC Configuration** - configure namespace-specific permissions for v2 resources
5. **Testing** - validate both API versions work in your environment before migration

## 🎯 Key Lessons Learned & Best Practices

### **Critical Success Factors (Based on Real Fixes)**

**1. Package Structure is Everything (provider-minio v0.16.5 fix):**
- The build system's Docker image embedding is **completely dependent** on finding `package/crossplane.yaml`
- This is not documented anywhere obvious but is **critical** for working providers
- Wrong filename → No Docker image embedding → "no command specified" errors → Provider won't start

**2. Dockerfile ENTRYPOINT vs CMD Matters:**
- Crossplane runtime expects `ENTRYPOINT ["/usr/local/bin/provider"]`
- Using `CMD` causes container startup failures in Kubernetes
- Environment variables handle arguments, not command-line parameters

**3. Environment Variable Configuration:**
- Never hardcode paths like `/tmp/k8s-webhook-server/serving-certs`
- Use `os.Getenv("WEBHOOK_TLS_CERT_DIR")` for runtime flexibility
- Crossplane sets these variables based on deployment configuration

**4. Build System Dependency:**
- The `github.com/rossigee/build` submodule is **essential**
- Upstream `crossplane/build` is broken (missing make targets)
- Always run `git submodule update --init --recursive` after checkout

### **Quality Assurance Process**

**Before Publishing Any Provider:**
```bash
# 1. Verify build system integrity
make lint && make reviewable && make test

# 2. Check package structure
ls -la package/crossplane.yaml  # Must exist, not package.yaml

# 3. Verify Docker image embedding
make xpkg.build
tar -tf _output/xpkg/linux_amd64/provider-*.xpkg | grep manifest.json

# 4. Inspect embedded Docker config  
tar -xf _output/xpkg/linux_amd64/provider-*.xpkg manifest.json
cat manifest.json | jq '.[0].Config' | grep -E '"(Entrypoint|Cmd)"'
# Should show: "Entrypoint": ["/usr/local/bin/provider"], no "Cmd" field

# 5. Test deployment in non-production cluster
kubectl apply -f test-provider.yaml
kubectl describe provider provider-name  # Check for startup errors
```

### **Deployment Validation**

**Provider Health Checks:**
```bash
# Check provider revision status
kubectl get providerrevisions | grep provider-name

# Verify pod is running (not CrashLoopBackOff)
kubectl get pods -n crossplane-system | grep provider-name

# Check for startup errors
kubectl logs -n crossplane-system deployment/provider-name

# Test webhook functionality (if applicable)
kubectl describe validatingwebhookconfigurations | grep provider-name
```

### **Emergency Troubleshooting Guide**

**"No command specified" errors:**
1. Extract .xpkg: `tar -tf provider.xpkg | head -10`
2. Look for Docker layers (sha256 files) - if missing, embedding failed
3. Check `package/crossplane.yaml` exists (not `package.yaml`)
4. Verify Dockerfile uses `ENTRYPOINT`, not `CMD`
5. Rebuild with correct structure

**TLS/Certificate errors:**
1. Check `cmd/provider/main.go` uses environment variables
2. Verify webhook configuration has correct certificate paths  
3. Check pod environment: `kubectl describe pod -n crossplane-system`
4. Look for `WEBHOOK_TLS_CERT_DIR` and related variables

**Build system errors:**
1. Verify correct build submodule: `git submodule status`
2. Should show `github.com/rossigee/build`, not `crossplane/build`
3. Re-initialize if wrong: `git submodule sync && git submodule update --init`
4. Remove any `.golangci.yml` files causing conflicts

### **Documentation Standards**

**Provider README Requirements:**
- Specify exact version compatibility (v2.0+ for modern providers)
- Include working examples for both v1 (cluster-scoped) and v2 (namespaced) APIs  
- Document all required environment variables and configuration
- Provide troubleshooting section with common issues
- Include build verification commands for contributors
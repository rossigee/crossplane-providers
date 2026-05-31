# Crossplane Providers

This repository contains a collection of Crossplane providers for managing external infrastructure and services through Kubernetes. Each provider enables declarative, GitOps-style management of specific platforms.

## Quick Start

```bash
# Clone and initialize submodules
git clone https://github.com/rossigee/crossplane-providers.git
cd crossplane-providers
git submodule update --init --recursive

# Build a provider
cd provider-minio
make lint reviewable test build
```

## Repository Structure

```
crossplane-providers/
├── provider-*/          # Individual provider implementations
├── build/               # Shared build system (rossigee/build submodule)
├── .github-templates/   # Standardized CI/CD workflows
├── package/             # Repository-level package outputs
└── template/            # Provider template for new providers
```

## Available Providers

See [INDEX.md](./INDEX.md) for a detailed list of all providers including versions, origins, and features.

## Build System

All providers use the [rossigee/build](https://github.com/rossigee/build) submodule for consistent build tooling:

- **make lint** - Lint code with golangci-lint
- **make reviewable** - Full pre-commit check (generate, lint, test)
- **make test** - Run unit tests with coverage
- **make generate** - Generate code and CRDs
- **make build** - Build the provider binary and local Docker image
- **make publish** - Build, package, and publish to registry

## Registry

All providers are published to `ghcr.io/rossigee/`:

```bash
# Example deployment
kubectl --kubeconfig ~/.kube/CLUSTER-admin.conf patch provider provider-minio \
  --type='merge' -p='{"spec":{"package":"ghcr.io/rossigee/provider-minio:v0.18.6"}}'
```

## Contributing

1. Use the `template/` directory as a starting point for new providers
2. Follow the standardized build system
3. Ensure CI/CD uses the `.github-templates/` workflows
4. Publish to `ghcr.io/rossigee/` registry

## Standards

- All providers use Go 1.26+ (or closest available)
- Standardized CI/CD with GitHub Actions
- Primary registry: `ghcr.io/rossigee`
- Build submodule: `rossigee/build`
- Branch: `master` (standardized 2025-07-24)

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
├── docs/                # Documentation and standards
│   ├── index.md        # Provider directory with status
│   ├── templates/       # Standardized CI/CD workflow templates
│   └── standards/      # Coding standards and templates
└── README.md           # This file
```

## Available Providers

See [docs/index.md](./docs/index.md) for a detailed list of all providers including versions, origins, API support, and standardization status.

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

1. Follow the standardized build system (rossigee/build)
2. Ensure CI/CD uses the `docs/templates/` workflows
3. Follow standards in `docs/standards/`
4. Publish to `ghcr.io/rossigee/` registry

## Standards

- All providers use Go 1.26+ (or closest available)
- Standardized CI/CD with GitHub Actions
- Primary registry: `ghcr.io/rossigee`
- Build submodule: `rossigee/build`

For detailed standardization status, see [docs/index.md](./docs/index.md).

# Crossplane Providers Project

> **⚠️ Disclaimer:** This is a **completely separate** set of Crossplane providers, **not related to, endorsed, or supported by** [Upbound](https://upbound.io/) or the [crossplane-contrib](https://github.com/crossplane-contrib) community. These are independent, hand-crafted providers maintained by [Ross Golder](https://github.com/rossigee).

A collection of lean, focused Crossplane providers designed for efficiency and operational simplicity.

## Philosophy

This project provides a curated set of **small, efficient, Crossplane v2-compatible providers** that prioritize:

- **Minimal Footprint**: Lightweight binaries with no unnecessary dependencies
- **No Upjet Baggage**: Hand-crafted controllers optimized for specific use cases, avoiding code generation bloat
- **v2 Compatibility**: Full support for Crossplane v2 patterns including namespaced resources with `.m.` API groups
- **Operational Simplicity**: Easy to deploy, monitor, and maintain
- **Import & Drift Detection**: All providers implement standard ExternalClient patterns for importing existing resources and detecting configuration drift

## Why Not Upjet?

Upjet is Crossplane's official code generation framework that produces providers from Terraform configurations. While comprehensive, it brings significant overhead:

- Large binary sizes due to unused Terraform resources
- Complex dependency chains
- Code that's difficult to customize or debug
- Slow build times and image sizes

Our approach: hand-crafted controllers for specific, well-defined resources. We build only what we need, when we need it.

## Provider Registry

### Production Ready

| Provider | Version | Released | Description | Registry | README | Docs |
|----------|---------|----------|-------------|----------|--------|------|
| provider-backblaze | v0.12.9 | 2025-10-30 | Backblaze B2 | `ghcr.io/rossigee/provider-backblaze` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-backblaze/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-backblaze/docs) |
| provider-cloudflare | v0.14.0 | 2026-01-05 | Cloudflare DNS | `ghcr.io/rossigee/provider-cloudflare` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-cloudflare/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-cloudflare/docs) |
| provider-discord | v0.9.1 | 2026-06-01 | Discord server | `ghcr.io/rossigee/provider-discord` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-discord/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-discord/docs) |
| provider-docker | v0.3.5 | 2025-10-30 | Docker containers | `ghcr.io/rossigee/provider-docker` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-docker/README.md) | — |
| provider-gitea | v0.8.0 | 2025-10-08 | Gitea repository | `ghcr.io/rossigee/provider-gitea` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-gitea/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-gitea/docs) |
| provider-harbor | v0.14.0 | 2026-06-06 | Harbor container registry | `ghcr.io/rossigee/provider-harbor` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-harbor/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-harbor/docs) |
| provider-http | — | — | Generic HTTP requests | `ghcr.io/rossigee/provider-http` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-http/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-http/docs) |
| provider-mailgun | v0.15.11 | 2026-05-30 | Mailgun email | `ghcr.io/rossigee/provider-mailgun` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-mailgun/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-mailgun/docs) |
| provider-matrix | — | — | Matrix chat | `ghcr.io/rossigee/provider-matrix` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-matrix/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-matrix/docs) |
| provider-minio | v0.19.1 | 2026-05-26 | MinIO object storage | `ghcr.io/rossigee/provider-minio` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-minio/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-minio/docs) |
| provider-openstack | — | — | OpenStack resources | `ghcr.io/rossigee/provider-openstack` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-openstack/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-openstack/docs) |
| provider-plausible | v0.2.1 | 2025-10-01 | Plausible Analytics | `ghcr.io/rossigee/provider-plausible` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-plausible/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-plausible/docs) |
| provider-vault | — | — | HashiCorp Vault | `ghcr.io/rossigee/provider-vault` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-vault/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-vault/docs) |

### In Development

| Provider | Version | Released | Description | Registry | README | Docs |
|----------|---------|----------|-------------|----------|--------|------|
| provider-btcpay | — | — | BTCPay Server | `ghcr.io/rossigee/provider-btcpay` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-btcpay/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-btcpay/docs) |
| provider-libvirt | — | — | KVM/libvirt VMs | `ghcr.io/rossigee/provider-libvirt` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-libvirt/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-libvirt/docs) |
| provider-signoz | v0.3.0 | 2025-09-29 | SigNoz observability | `ghcr.io/rossigee/provider-signoz` | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-signoz/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-signoz/docs) |

### Backlog

| Provider | Version | Released | Description | README | Docs |
|----------|---------|----------|-------------|--------|------|
| provider-hostinger | v0.1.0 | 2026-01-08 | Hostinger hosting | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-hostinger/README.md) | — |
| provider-keycloak | — | — | Keycloak identity | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-keycloak/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-keycloak/docs) |
| provider-namecheap | v0.5.2 | 2025-10-23 | Namecheap domains | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-namecheap/README.md) | [docs/](https://github.com/rossigee/crossplane-providers/tree/master/provider-namecheap/docs) |
| provider-rabbitmq | v0.2.0 | 2026-06-01 | RabbitMQ messaging | [README](https://github.com/rossigee/crossplane-providers/blob/master/provider-rabbitmq/README.md) | — |

## Compliance Requirements

All providers in this project must adhere to Crossplane standards:

### Build System

- Use `rossigee/build` submodule (upstream `crossplane/build` is broken)
- Standardized Makefile targets: `lint`, `reviewable`, `test`, `generate`, `build`, `publish`
- Package metadata: `package/crossplane.yaml`
- Dockerfile: `ENTRYPOINT` (Crossplane injects args via env vars)

### Architecture

- Support for Crossplane v2 patterns (dual-scope: cluster-scoped + namespaced)
- Standard ExternalClient interface for all controllers
- Import existing resources capability
- Drift detection support

### API Conventions

| Pattern | API Group | Scope | Example |
|---------|-----------|-------|---------|
| Legacy v1 | `provider.crossplane.io` | Cluster | `apiVersion: minio.crossplane.io/v1` |
| Modern v2 | `provider.m.crossplane.io` | Namespaced | `apiVersion: minio.m.crossplane.io/v1beta1` |

### CI/CD

- GitHub Actions with "CI Builds, Release Publishes" pattern
- No tag conflicts between CI and release workflows
- Lint and test validation on all PRs
- Security scanning (govulncheck, gosec, CodeQL)

## Quick Start

> **Note:** In most cases, users will want to work with individual providers directly (see each provider's README). The commands below are mainly useful for **maintainers** performing batch operations across providers.

```bash
# Initialize build submodule
git submodule update --init --recursive

# Build and publish a provider
cd provider-minio
make publish VERSION=v0.16.5 PLATFORMS=linux_amd64
```

## Documentation

- [Introspection and Drift Detection](introspection_and_drift_detection.md)
- [Provider Vault Migration](provider_vault_migration.md)

## Contributing

1. Follow the provider template structure
2. Implement ExternalClient interface for all controllers
3. Use environment variables for configuration (no hardcoded paths)
4. Ensure `package/crossplane.yaml` exists with correct format
5. Test with `make reviewable` before submitting

## License

Apache 2.0
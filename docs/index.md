# Provider Index

This file lists all Crossplane providers in the crossplane-providers repository with their metadata.

## Legend

- **Origin**: `rossigee` = maintained by rossigee, `crossplane-contrib` = third-party upstream
- **Go Version**: Go compiler version
- **Runtime**: crossplane-runtime version (v2)
- **v1 API**: Cluster-scoped resources (legacy, crossplane.io/v1)
- **v2 API**: Namespaced resources (modern, .m.crossplane.io/v1beta1)
- **Build**: Whether using rossigee/build submodule
- **Upjet/Terraform**: Whether based on [upjet](https://github.com/crossplane/upjet) code generation or wraps Terraform providers
- **Status**: Production-ready, In Development, or Standard/Third-party

## Providers

| Provider | Latest Version | Origin | Go Version | Runtime | v1 API | v2 API | Build | Upjet/TF | Status | Notes |
|----------|---------------|--------|------------|--------|--------|-------|----------|--------|-------|
| [provider-backblaze](provider-backblaze) | v0.12.9 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](provider-btcpay) | v0.4.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](provider-cloudflare) | v0.13.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](provider-discord) | v0.9.0 | rossigee | 1.26.5 | v2.3.3 | Yes | No | Yes | No | In Dev | Discord server management |
| [provider-docker](provider-docker) | v0.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | Docker containers and compose stacks |
| [provider-gitea](provider-gitea) | v0.8.2 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | Gitea repository management |
| [provider-harbor](provider-harbor) | v0.13.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Harbor container registry |
| [provider-hostinger](provider-hostinger) | v0.1.0 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Hostinger VPS and cloud services |
| [provider-http](provider-http) | v1.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | Standard | Generic HTTP request resources |
| [provider-keycloak](provider-keycloak) | (no tags) | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Keycloak identity management |
| [provider-libvirt](provider-libvirt) | (no tags) | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | Upjet | In Dev | KVM/libvirt virtual machines |
| [provider-mailgun](provider-mailgun) | v0.14.3 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | Production | Mailgun email service |
| [provider-matrix](provider-matrix) | v0.1.0 | crossplane-contrib | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | Standard | Matrix homeserver management |
| [provider-minio](provider-minio) | v0.19.1 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | MinIO object storage (VSHN-maintained) |
| [provider-namecheap](provider-namecheap) | (no tags) | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Standard | Namecheap domains and DNS |
| [provider-openstack](provider-openstack) | v0.9.0 | crossplane-contrib | 1.26.5 | v2.3.3 | Yes | Yes | Yes | Upjet | Standard | OpenStack cloud resources |
| [provider-plausible](provider-plausible) | v0.2.1 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Plausible Analytics |
| [provider-rabbitmq](provider-rabbitmq) | v0.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | RabbitMQ management |
| [provider-signoz](provider-signoz) | v0.2.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | In Dev | SigNoz observability platform |
| [provider-vault](provider-vault) | (no tags) | rossigee | 1.26.5 | v2.4.0-rc.0 | Yes | Yes | No | No | In Dev | HashiCorp Vault secrets management |

## Summary Statistics

- **Total Providers**: 20
- **With v2 (namespaced) APIs**: 19 (95%)
- **Production Ready**: 5 (cloudflare, harbor, mailgun, minio, plausible)
- **In Development**: 12
- **Standard/Third-party**: 3

## Standardization Status

### Core Metrics

| Metric | Status | Compliance | Notes |
|--------|--------|-----------|-------|
| Go Version | ✅ 100% | 20/20 | All on 1.26.5 |
| Build System | ✅ 100% | 20/20 | All use rossigee/build submodule |
| Registry | ✅ 100% | 20/20 | All use ghcr.io/rossigee |
| v1beta1 APIs | ✅ 95% | 19/20 | provider-discord pending |
| CI/CD Workflows | ✅ 100% | 20/20 | All have GitHub Actions workflows |

### Runtime Version Distribution

Runtime fragmentation is the primary consistency concern:

| Version | Count | Providers | Status |
|---------|-------|-----------|--------|
| v2.3.3 (stable) | 14 | btcpay, cloudflare, docker, gitea, harbor, http, libvirt, matrix, minio, namecheap, openstack, plausible, rabbitmq, signoz | ✅ Recommended |
| v2.4.0-rc.0 (candidate) | 5 | backblaze, hostinger, keycloak, mailgun, vault | ⚠️ Pre-release |

**Target**: Align all providers to v2.3.3 (or evaluate v2.4.0-rc.0 stability for broader adoption)

### Quality Metrics (Emerging)

| Category | Status | Notes |
|----------|--------|-------|
| Test Coverage | 📊 Baseline | Not yet standardized across all providers |
| Security Audit | 📊 Baseline | Dependency scanning recommended |
| Documentation | 📊 Baseline | API docs vary by provider; target: consistent |
| Release Cadence | 📊 Baseline | No SLA defined; target: regular updates |

**Overall Consistency Score**: ~91% (weighted by metric importance)

- Go Version: 100% (weight: 15%) = 15%
- Build System: 100% (weight: 15%) = 15%
- Registry: 100% (weight: 10%) = 10%
- Runtime Version: 70% (weight: 25%) = 17.5% (14/20 on v2.3.3 + 5/20 on pre-release)
- v1beta1 APIs: 95% (weight: 15%) = 14.25%
- CI/CD Workflows: 100% (weight: 5%) = 5%
- **Weighted Total = 77.25% / 0.85 scale ≈ 91%**

### Immediate Priorities

**Tier 1 (Blocking consistency):**
1. ✅ ~~Align runtime versions: bump provider-openstack to v2.3.3~~ (completed)
2. Add v1beta1 API: provider-discord

**Tier 2 (Operational readiness):**
3. ✅ ~~Add CI/CD workflows to provider-vault~~ (completed)
4. Evaluate v2.4.0-rc.0 adoption: 5 providers already using; assess release timeline

**Tier 3 (Quality investment):**
5. Standardize test coverage reporting
6. Establish security scanning baseline

## Registry Images

All rossigee providers are published to `ghcr.io/rossigee/`:

```bash
# Examples
ghcr.io/rossigee/provider-minio:v0.19.1
ghcr.io/rossigee/provider-mailgun:v0.14.3
ghcr.io/rossigee/provider-harbor:v0.13.0
```

## Directory Structure

```
crossplane-providers/
├── docs/                    # Documentation and templates
│   ├── templates/          # GitHub Actions workflow templates
│   ├── standards/          # Coding standards and templates
│   └── consistency-archive.md  # Historical standardization details
├── provider-*/             # Individual provider repositories
├── README.md               # Repository entry point
└── AGENTS.md               # Agent instructions
```

---

*Last updated: 2026-07-29* (audit: go.mod analysis, runtime scan, API verification; fixes: openstack v2.3.3, vault CI/CD added)

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
| [provider-backblaze](provider-backblaze) | v0.12.9 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | In Dev | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](provider-btcpay) | v0.4.0 | rossigee | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | In Dev | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](provider-cloudflare) | v0.13.0 | rossigee | 1.26 | v2.3.2 | No | Yes | Yes | No | Production | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](provider-discord) | v0.9.0 | rossigee | 1.26.3 | v2.3.2 | Yes | No | Yes | No | In Dev | Discord server management |
| [provider-docker](provider-docker) | v0.1.0 | rossigee | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | In Dev | Docker containers and compose stacks |
| [provider-gitea](provider-gitea) | v0.8.2 | rossigee | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | In Dev | Gitea repository management |
| [provider-harbor](provider-harbor) | v0.13.0 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | Production | Harbor container registry |
| [provider-hostinger](provider-hostinger) | v0.1.0 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | In Dev | Hostinger VPS and cloud services |
| [provider-http](provider-http) | v1.1.0 | rossigee | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | Standard | Generic HTTP request resources |
| [provider-keycloak](provider-keycloak) | (no tags) | rossigee | 1.26 | v2.3.2 | No | Yes | Yes | No | In Dev | Keycloak identity management |
| [provider-libvirt](provider-libvirt) | (no tags) | rossigee | 1.26.0 | v2.3.2 | Yes | Yes | Yes | Upjet | In Dev | KVM/libvirt virtual machines |
| [provider-mailgun](provider-mailgun) | v0.14.3 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | Production | Mailgun email service |
| [provider-matrix](provider-matrix) | v0.1.0 | crossplane-contrib | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | Standard | Matrix homeserver management |
| [provider-minio](provider-minio) | v0.19.1 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | Production | MinIO object storage (VSHN-maintained) |
| [provider-namecheap](provider-namecheap) | (no tags) | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | Standard | Namecheap domains and DNS |
| [provider-openstack](provider-openstack) | v0.9.0 | crossplane-contrib | 1.25.3 | v2.3.2 | Yes | Yes | Yes | Upjet | Standard | OpenStack cloud resources |
| [provider-plausible](provider-plausible) | v0.2.1 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | Production | Plausible Analytics |
| [provider-rabbitmq](provider-rabbitmq) | v0.1.0 | rossigee | 1.26.3 | v2.3.2 | Yes | Yes | Yes | No | In Dev | RabbitMQ management |
| [provider-signoz](provider-signoz) | v0.2.0 | rossigee | 1.26.3 | v2.3.2 | No | Yes | Yes | No | In Dev | SigNoz observability platform |
| [provider-vault](provider-vault) | (no tags) | rossigee | 1.26.3 | (standalone) | Yes | Yes | No | No | In Dev | HashiCorp Vault secrets management |

## Summary Statistics

- **Total Providers**: 20
- **rossigee-maintained**: 18 (90%)
- **crossplane-contrib**: 2 (10%)
- **With v2 (namespaced) APIs**: 18
- **Production Ready**: 5 (cloudflare, harbor, mailgun, minio, plausible)
- **In Development**: 12
- **Standard/Third-party**: 3

## Standardization Status

| Metric | Status | Notes |
|--------|--------|-------|
| Build System | ✅ 100% | All use rossigee/build (except vault) |
| Registry | ✅ 100% | All use ghcr.io/rossigee |
| Go Version | ✅ 95% | 19/20 on 1.26.3; openstack (1.25.3) needs update |
| Runtime | ✅ 95% | 19/20 on v2.3.2; openstack pending |
| v1beta1 APIs | ⚠️ 90% | 18/20 have namespaced APIs; discord, vault pending |
| CI/CD | ✅ 100% | All have GitHub Actions workflows |

**Overall Consistency Score**: ~95%

### Known Gaps

- **Go Version**: Bump openstack to 1.26.3
- **APIs**: Add v1beta1 namespaced APIs to provider-discord, provider-vault
- **Build**: provider-vault uses standalone build (not rossigee/build submodule)

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

*Last updated: 2026-06-09*

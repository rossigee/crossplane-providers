# Provider Index

This file lists all providers in the crossplane-providers repository with their metadata.

## Legend

- **Origin**: `rossigee` = maintained by rossigee, `crossplane-contrib` = third-party upstream
- **v1 API**: Cluster-scoped resources (legacy, crossplane.io/v1)
- **v2 API**: Namespaced resources (modern, .m.crossplane.io/v1beta1)
- **Build**: Whether using rossigee/build submodule
- **Upjet/Terraform**: Whether based on [upjet](https://github.com/crossplane/upjet) code generation or wraps Terraform providers

## Providers

| Provider | Latest Version | Origin | Go Version | v1 API | v2 API | Build | Upjet/Terraform | Notes |
|----------|---------------|--------|------------|--------|--------|-------|-----------------|-------|
| [provider-backblaze](provider-backblaze) | v0.12.9 | rossigee | 1.26.3 | No | Yes | Yes | No | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](provider-btcpay) | v0.4.0 | rossigee | 1.26.3 | Yes | Yes | Yes | No | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](provider-cloudflare) | v0.13.0 | rossigee | 1.26 | No | Yes | Yes | No | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](provider-discord) | v0.9.0 | rossigee | 1.26.3 | Yes | No | Yes | No | Discord server management (guilds, channels, roles) |
| [provider-docker](provider-docker) | v0.1.0 | rossigee | 1.26.3 | Yes | Yes | Yes | No | Docker containers and compose stacks |
| [provider-gitea](provider-gitea) | v0.8.2 | rossigee | 1.26.3 | Yes | Yes | Yes | No | Gitea repository management |
| [provider-harbor](provider-harbor) | v0.13.0 | rossigee | 1.26.3 | No | Yes | Yes | No | Harbor container registry |
| [provider-hostinger](provider-hostinger) | v0.1.0 | rossigee | 1.26.3 | No | Yes | Yes | No | Hostinger VPS and cloud services |
| [provider-http](provider-http) | v1.1.0 | rossigee | 1.26.3 | Yes | Yes | Yes | No | Generic HTTP request resources |
| [provider-libvirt](provider-libvirt) | (no tags) | rossigee | 1.26.0 | Yes | Yes | Yes | Upjet | KVM/libvirt virtual machines |
| [provider-mailgun](provider-mailgun) | v0.14.3 | rossigee | 1.26.3 | No | Yes | Yes | No | Mailgun email service (domains, lists, routes) |
| [provider-matrix](provider-matrix) | v0.1.0 | crossplane-contrib | 1.26.3 | Yes | Yes | Yes | No | Matrix homeserver (users, rooms, spaces) |
| [provider-minio](provider-minio) | v0.19.1 | rossigee | 1.26.3 | No | Yes | Yes | No | MinIO object storage (VSHN-maintained) |
| [provider-namecheap](provider-namecheap) | (no tags) | rossigee | 1.26.3 | No | Yes | Yes | No | Namecheap domains and DNS records |
| [provider-openstack](provider-openstack) | v0.9.0 | crossplane-contrib | 1.25.3 | Yes | Yes | Yes | Upjet | OpenStack cloud resources |
| [provider-plausible](provider-plausible) | v0.2.1 | rossigee | 1.26.3 | No | Yes | Yes | No | Plausible Analytics (sites, goals) |
| [provider-keycloak](provider-keycloak) | (no tags) | rossigee | 1.26 | No | Yes | Yes | No | Keycloak identity management |
| [provider-signoz](provider-signoz) | v0.2.0 | rossigee | 1.26.3 | No | Yes | Yes | No | SigNoz observability platform |

## Summary Statistics

- **Total Providers**: 18
- **rossigee-maintained**: 16 (89%)
- **crossplane-contrib (third-party)**: 2 (12%)
- **With v2 (namespaced) APIs**: 16
- **With v1 (cluster-scoped) APIs**: 7

## Registry Images

All rossigee providers are published to `ghcr.io/rossigee/`:

```bash
# Example images
ghcr.io/rossigee/provider-minio:v0.19.1
ghcr.io/rossigee/provider-mailgun:v0.14.3
ghcr.io/rossigee/provider-harbor:v0.13.0
```

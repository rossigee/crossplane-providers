---
title: Providers
description: All Crossplane providers with versions and status
---

# Providers

A complete list of all Crossplane providers in this repository.

| Provider | Version | Status | Description |
|----------|---------|--------|-------------|
| [provider-backblaze](https://github.com/rossigee/provider-backblaze) | v0.14.0 | In Dev | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](https://github.com/rossigee/provider-btcpay) | v0.6.0 | In Dev | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](https://github.com/rossigee/provider-cloudflare) | v0.16.0 | Production | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](https://github.com/rossigee/provider-discord) | v0.16.0 | In Dev | Discord server management |
| [provider-docker](https://github.com/rossigee/provider-docker) | v0.5.0 | In Dev | Docker containers and compose stacks |
| [provider-gitea](https://github.com/rossigee/provider-gitea) | v0.12.0 | In Dev | Gitea repository management |
| [provider-harbor](https://github.com/rossigee/provider-harbor) | v0.19.0 | Production | Harbor container registry |
| [provider-hostinger](https://github.com/rossigee/provider-hostinger) | v0.2.2 | In Dev | Hostinger VPS and cloud services |
| [provider-http](https://github.com/rossigee/provider-http) | v1.4.0 | In Dev | Generic HTTP request resources |
| [provider-keycloak](https://github.com/rossigee/provider-keycloak) | v0.4.0 | In Dev | Keycloak identity management |
| [provider-libvirt](https://github.com/rossigee/provider-libvirt) | v0.11.0 | In Dev | KVM/libvirt virtual machines |
| [provider-mailgun](https://github.com/rossigee/provider-mailgun) | v0.21.0 | Production | Mailgun email service |
| [provider-matrix](https://github.com/crossplane-contrib/provider-matrix) | v0.5.0 | Community | Matrix homeserver management |
| [provider-minio](https://github.com/rossigee/provider-minio) | v0.21.0 | Production | MinIO object storage |
| [provider-namecheap](https://github.com/rossigee/provider-namecheap) | v0.7.1 | Community | Namecheap domains and DNS |
| [provider-openstack](https://github.com/crossplane-contrib/provider-openstack) | v1.2.0 | Community | OpenStack cloud resources |
| [provider-plausible](https://github.com/rossigee/provider-plausible) | v0.4.0 | Production | Plausible Analytics |
| [provider-rabbitmq](https://github.com/rossigee/provider-rabbitmq) | v0.5.0 | In Dev | RabbitMQ management |
| [provider-signoz](https://github.com/rossigee/provider-signoz) | v0.6.1 | In Dev | SigNoz observability platform |
| [provider-vault](https://github.com/rossigee/provider-vault) | v0.3.0 | In Dev | HashiCorp Vault secrets management |

## Status Definitions

### Production

A provider is classified as **Production** when all of the following criteria are met:

1. **Has been deployed and used successfully in a production environment** - Real workloads are running without issues
2. **API is stable** - No breaking changes in recent releases (v1.0+ or 3+ stable releases)
3. **Comprehensive CRD coverage** - Main resources are implemented and tested
4. **Community adoption** - In use by users beyond the maintainer
5. **Documentation complete** - README, examples, and troubleshooting docs are in place

### In Dev

A provider is classified as **In Dev** when any of the following apply:

1. **Under active development** - New features being added, API may evolve
2. **Limited production testing** - Not yet proven in production or limited adoption
3. **Pre-v1.0 releases** - API may still have breaking changes between releases
4. **Partial coverage** - Core resources implemented but not comprehensive

### Community

A provider is classified as **Community** when it meets these criteria:

1. **Forked from crossplane-contrib** - Originally from third-party, maintained by rossigee
2. **External origin** - Not originally developed by rossigee
3. **Maintained for compatibility** - Kept up-to-date with Crossplane releases

## Criteria Rationale

- **Production status** requires real-world deployment because theoretical completeness doesn't guarantee operational reliability
- **In Dev** is the default state for new providers until proven in production
- **Community** status acknowledges providers forked from external sources while still being actively maintained

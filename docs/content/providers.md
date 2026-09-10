---
title: Providers
description: All Crossplane providers with versions and status
---

# Providers

A complete list of all Crossplane providers in this repository.

All providers are currently classified as **In Dev** as we cannot verify the production deployment criteria for any of them.

| Provider | Version | Description |
|----------|---------|-------------|
| [provider-backblaze](https://github.com/rossigee/provider-backblaze) | v0.14.0 | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](https://github.com/rossigee/provider-btcpay) | v0.6.0 | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](https://github.com/rossigee/provider-cloudflare) | v0.16.0 | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](https://github.com/rossigee/provider-discord) | v0.16.0 | Discord server management |
| [provider-docker](https://github.com/rossigee/provider-docker) | v0.5.0 | Docker containers and compose stacks |
| [provider-gitea](https://github.com/rossigee/provider-gitea) | v0.12.0 | Gitea repository management |
| [provider-harbor](https://github.com/rossigee/provider-harbor) | v0.19.0 | Harbor container registry |
| [provider-hostinger](https://github.com/rossigee/provider-hostinger) | v0.2.2 | Hostinger VPS and cloud services |
| [provider-http](https://github.com/rossigee/provider-http) | v1.4.0 | Generic HTTP request resources |
| [provider-keycloak](https://github.com/rossigee/provider-keycloak) | v0.4.0 | Keycloak identity management |
| [provider-libvirt](https://github.com/rossigee/provider-libvirt) | v0.11.0 | KVM/libvirt virtual machines |
| [provider-mailgun](https://github.com/rossigee/provider-mailgun) | v0.21.0 | Mailgun email service |
| [provider-matrix](https://github.com/crossplane-contrib/provider-matrix) | v0.5.0 | Matrix homeserver management |
| [provider-minio](https://github.com/rossigee/provider-minio) | v0.21.0 | MinIO object storage |
| [provider-namecheap](https://github.com/rossigee/provider-namecheap) | v0.7.1 | Namecheap domains and DNS |
| [provider-openstack](https://github.com/crossplane-contrib/provider-openstack) | v1.2.0 | OpenStack cloud resources |
| [provider-plausible](https://github.com/rossigee/provider-plausible) | v0.4.0 | Plausible Analytics |
| [provider-rabbitmq](https://github.com/rossigee/provider-rabbitmq) | v0.5.0 | RabbitMQ management |
| [provider-signoz](https://github.com/rossigee/provider-signoz) | v0.6.1 | SigNoz observability platform |
| [provider-vault](https://github.com/rossigee/provider-vault) | v0.3.0 | HashiCorp Vault secrets management |

## Status Definitions

### In Dev

A provider is classified as **In Dev** when any of the following apply:

1. **Under active development** - New features being added, API may evolve
2. **Limited production testing** - Not yet proven in production or limited adoption
3. **Pre-v1.0 releases** - API may still have breaking changes between releases
4. **Partial coverage** - Core resources implemented but not comprehensive

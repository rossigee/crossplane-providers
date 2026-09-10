---
title: Providers
description: All Crossplane providers with versions and status
---

# Providers

This page contains the full provider table. For background on the columns, see the [Legend](/crossplane-providers/#legend).

> **Note**: This table is automatically generated. See `scripts/audit_standards.sh` for details.

## Production Ready

| Provider | Latest | Status | Notes |
|----------|--------|--------|-------|
| [provider-cloudflare](/crossplane-providers/provider-cloudflare) | v0.16.0 | Production | Cloudflare DNS, security, WAF |
| [provider-harbor](/crossplane-providers/provider-harbor) | v0.19.0 | Production | Harbor container registry |
| [provider-mailgun](/crossplane-providers/provider-mailgun) | v0.21.0 | Production | Mailgun email service |
| [provider-minio](/crossplane-providers/provider-minio) | v0.21.0 | Production | MinIO object storage |
| [provider-plausible](/crossplane-providers/provider-plausible) | v0.4.0 | Production | Plausible Analytics |

## In Development

| Provider | Latest | Runtime | Notes |
|----------|--------|---------|-------|
| [provider-backblaze](/crossplane-providers/provider-backblaze) | v0.14.0 | v2.5.0 | Backblaze B2 storage |
| [provider-btcpay](/crossplane-providers/provider-btcpay) | v0.6.0 | v2.5.0 | BTCPay Server |
| [provider-discord](/crossplane-providers/provider-discord) | v0.16.0 | v2.5.0 | Discord management |
| [provider-docker](/crossplane-providers/provider-docker) | v0.5.0 | v2.5.0 | Docker containers |
| [provider-gitea](/crossplane-providers/provider-gitea) | v0.12.0 | v2.5.0 | Gitea repos |
| [provider-hostinger](/crossplane-providers/provider-hostinger) | v0.2.2 | v2.5.0 | Hostinger VPS |
| [provider-keycloak](/crossplane-providers/provider-keycloak) | v0.4.0 | v2.5.0 | Keycloak identity |
| [provider-rabbitmq](/crossplane-providers/provider-rabbitmq) | v0.5.0 | v2.5.0 | RabbitMQ |
| [provider-signoz](/crossplane-providers/provider-signoz) | v0.6.1 | v2.5.0 | SigNoz observability |
| [provider-vault](/crossplane-providers/provider-vault) | v0.3.0 | v2.5.0 | HashiCorp Vault |

## Standard / Third-Party

| Provider | Latest | Upjet | Notes |
|----------|--------|-------|-------|
| [provider-http](/crossplane-providers/provider-http) | v1.4.0 | No | Generic HTTP |
| [provider-libvirt](/crossplane-providers/provider-libvirt) | v0.11.0 | Yes | KVM/libvirt VMs |
| [provider-matrix](/crossplane-providers/provider-matrix) | v0.5.0 | No | Matrix homeserver |
| [provider-namecheap](/crossplane-providers/provider-namecheap) | v0.7.1 | No | Namecheap DNS |
| [provider-openstack](/crossplane-providers/provider-openstack) | v1.2.0 | Yes | OpenStack |

## Full Table

<details>
<summary>Click to expand full table with all columns</summary>

| Provider | Latest Version | Origin | Go Version | Runtime | v1 API | v2 API | Build | Upjet/TF | Status | Notes |
|----------|---------------|--------|------------|--------|--------|-------|----------|--------|-------|
| [provider-backblaze](/crossplane-providers/provider-backblaze) | v0.14.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | In Dev | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](/crossplane-providers/provider-btcpay) | v0.6.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | In Dev | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](/crossplane-providers/provider-cloudflare) | v0.16.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Production | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](/crossplane-providers/provider-discord) | v0.16.0 | rossigee | 1.27.1 | v2.5.0 | Yes | No | Yes | No | In Dev | Discord server management |
| [provider-docker](/crossplane-providers/provider-docker) | v0.5.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | In Dev | Docker containers and compose stacks |
| [provider-gitea](/crossplane-providers/provider-gitea) | v0.12.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | In Dev | Gitea repository management |
| [provider-harbor](/crossplane-providers/provider-harbor) | v0.19.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Production | Harbor container registry |
| [provider-hostinger](/crossplane-providers/provider-hostinger) | v0.2.2 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | In Dev | Hostinger VPS and cloud services |
| [provider-http](/crossplane-providers/provider-http) | v1.4.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | Standard | Generic HTTP request resources |
| [provider-keycloak](/crossplane-providers/provider-keycloak) | v0.4.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | In Dev | Keycloak identity management |
| [provider-libvirt](/crossplane-providers/provider-libvirt) | v0.11.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | Upjet | In Dev | KVM/libvirt virtual machines |
| [provider-mailgun](/crossplane-providers/provider-mailgun) | v0.21.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Production | Mailgun email service |
| [provider-matrix](/crossplane-providers/provider-matrix) | v0.5.0 | crossplane-contrib | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | Standard | Matrix homeserver management |
| [provider-minio](/crossplane-providers/provider-minio) | v0.21.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Production | MinIO object storage (VSHN-maintained) |
| [provider-namecheap](/crossplane-providers/provider-namecheap) | v0.7.1 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Standard | Namecheap domains and DNS |
| [provider-openstack](/crossplane-providers/provider-openstack) | v1.2.0 | crossplane-contrib | 1.27.1 | v2.5.0 | Yes | Yes | Yes | Upjet | Standard | OpenStack cloud resources |
| [provider-plausible](/crossplane-providers/provider-plausible) | v0.4.0 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | Production | Plausible Analytics |
| [provider-rabbitmq](/crossplane-providers/provider-rabbitmq) | v0.5.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | In Dev | RabbitMQ management |
| [provider-signoz](/crossplane-providers/provider-signoz) | v0.6.1 | rossigee | 1.27.1 | v2.5.0 | No | Yes | Yes | No | In Dev | SigNoz observability platform |
| [provider-vault](/crossplane-providers/provider-vault) | v0.3.0 | rossigee | 1.27.1 | v2.5.0 | Yes | Yes | Yes | No | In Dev | HashiCorp Vault secrets management |

</details>

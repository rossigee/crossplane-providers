# Crossplane Providers

[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://rossigee.github.io/crossplane-providers/)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE)
[![20 Providers](https://img.shields.io/badge/providers-20-orange)](https://rossigee.github.io/crossplane-providers/)

Native Crossplane providers for managing external infrastructure
and services through Kubernetes — declarative, GitOps-style, no Terraform.

This is a **meta-repo**: each `provider-*` directory is a git submodule
pointing at its own repository (see `.gitmodules`). File issues and PRs
**per-provider**; this repo tracks shared standards, tooling, and docs.

## Providers

20 providers. See the [Providers page](https://rossigee.github.io/crossplane-providers/) for the full list.

See [docs](https://rossigee.github.io/crossplane-providers/) for versions and live standardization status.

## Use

**Requires Crossplane core >= v2.5.** See [Standards](https://rossigee.github.io/crossplane-providers/standards/) for the full platform baseline.

```bash
# Install a provider (example)
kubectl crossplane install provider ghcr.io/rossigee/provider-minio:v0.21.0
```

**v2 APIs:** All 20 providers use Crossplane v2 namespaced APIs (`.m.crossplane.io/v1beta1`).
Cluster-scoped v1 APIs are deprecated; v2 provides namespace-scoped resources for better multi-tenancy.
Per-resource examples live in each provider's `examples/` and `README.md`.

## Develop

```bash
# Clone with submodules (HTTPS recommended for contributors)
git clone https://github.com/rossigee/crossplane-providers.git
cd crossplane-providers
git submodule update --init --recursive

# Per-provider workflow
cd provider-minio
make lint reviewable test build
make publish VERSION=vX.Y.Z PLATFORMS=linux_amd64
```

Shared tooling: [rossigee/build](https://github.com/rossigee/build) submodule
(`rossigee-lint-fixes` branch). It is a small fork of `crossplane/build`:
adds `govulncheck` to `reviewable`, bumps `golangci-lint` to `2.13.2` with
vendor-before-generate, and pins CLI `v2.5.0` from the working
`cli.crossplane.io` URL. Upstream lacks all three. CI templates live in
[docs/templates/](./docs/templates/).

## Contribute

New providers must be **native Crossplane implementations** — no `upjet`,
`terraform-plugin-sdk/framework`, `terraform-provider-*`, or Hashicorp
dependencies (smaller binaries, simpler code, fewer CVEs). Upstream-derived
exceptions (openstack, libvirt) are grandfathered, not a pattern to copy.

* New provider checklist: `docs/standards/readme-standard.md` (README shape),
  `docs/standards/platform.md` (version floor), `docs/templates/` (CI).
* Standards source of truth: `scripts/audit_standards.sh`.
* Participation: see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Support

* Issues: per-provider GitHub repo (not here).
* Docs site: `https://rossigee.github.io/crossplane-providers/` (from `docs/`).
* Registry: `ghcr.io/rossigee/provider-*:tag` (fully qualified, no default registry).
* License: [Apache-2.0](./LICENSE).

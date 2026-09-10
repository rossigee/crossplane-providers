# Crossplane Providers

Hand-written native Crossplane providers for managing external infrastructure
and services through Kubernetes — declarative, GitOps-style, no Terraform.

This is a **meta-repo**: each `provider-*` directory is a git submodule
pointing at its own repository (see `.gitmodules`). File issues and PRs
**per-provider**; this repo tracks shared standards, tooling, and docs.

## Providers

20 providers. 5 Production (cloudflare, harbor, mailgun, minio, plausible),
12 In Development, 3 Standard/third-party. All published to `ghcr.io/rossigee/`.

See [docs/index.md](./docs/index.md) for versions, origins, API scope (v1/v2),
and live standardization status (regenerated via `scripts/audit_standards.sh`).

## Use

**Requires Crossplane core >= v2.5.** See
[docs/standards/platform.md](./docs/standards/platform.md) for the full
platform baseline (runtime `v2.5.0` via `rossigee/crossplane-runtime` fork,
CLI `v2.5.0`, Go `1.27.1`).

```bash
# Install a provider (example)
kubectl crossplane install provider ghcr.io/rossigee/provider-minio:v0.20.0
```

**v1 vs v2 APIs:** v1 = legacy cluster-scoped (`*.crossplane.io/v1alpha1`).
v2 = namespaced (`.m.crossplane.io/v1beta1`, `namespace:`-scoped, better
multi-tenancy). Use v2 for anything new; v1 keeps working where present.
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

New providers must be **hand-written native Crossplane** — no `upjet`,
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

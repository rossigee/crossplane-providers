# Crossplane Providers Repository

Meta-repo of native Crossplane providers (GitOps management of
external platforms). Each `provider-*` dir is a git submodule with its own
repo — file issues/PRs per-provider. This repo tracks shared standards.

## Architectural mandate: no Terraform/Upjet

Native implementations only. Forbidden: `upjet`, `terraform-plugin-sdk`,
`terraform-plugin-framework`, `terraform-provider-*`, any Hashicorp terraform
dependency. Rationale: 5–10x smaller binaries, simpler direct-API clients,
fewer CVEs, better K8s integration. Contributions using terraform scaffolding
are rejected.

## Providers

20 providers; see [docs/index.md](./docs/index.md) for versions, origins, API
scope, and audit-generated standardization status. Production: cloudflare,
harbor, mailgun, minio, plausible. Registry: `ghcr.io/rossigee/provider-*:tag`
(fully qualified).

## Structure

```
provider-xxx/
├── apis/              # CRD types (v1alpha1 cluster-scoped and/or v1beta1 namespaced)
├── cmd/provider/      # Main entry point (env-var config, no hardcoded cert paths)
├── config/            # Provider setup
├── examples/          # Sample manifests
├── internal/          # Controllers + API clients
├── package/           # crossplane.yaml (NOT package.yaml) + CRDs
└── Makefile           # rossigee/build orchestration
```

## Build

```bash
git submodule update --init --recursive   # mandatory after checkout
make lint            # golangci-lint via build submodule
make reviewable      # generate + lint + test + govulncheck
make test            # unit tests
make generate        # CRDs
make build           # binary + local image
make publish VERSION=vX.Y.Z PLATFORMS=linux_amd64   # full publish (recommended)
make xpkg.build      # Crossplane package with embedded runtime
```

Prerequisites and version floor: [docs/standards/platform.md](./docs/standards/platform.md)
(Crossplane core `>= v2.5`, runtime `v2.5.0` via `rossigee/crossplane-runtime`
fork, CLI `v2.5.0`, Go `1.27.1`). Build submodule must be
`https://github.com/rossigee/build` (`rossigee-lint-fixes`); upstream
`crossplane/build` lacks targets. Never add a local `.golangci.yml`.

## Critical gotchas

* `package/crossplane.yaml` with `kind: Provider` — required for
  `--embed-runtime-image`; `package.yaml` silently ships an imageless `.xpkg`.
* Dockerfile `ENTRYPOINT ["/usr/local/bin/provider"]`, never `CMD`.
* `cmd/provider/main.go`: `CertDir: os.Getenv("WEBHOOK_TLS_CERT_DIR")`, never
  hardcoded paths.
* Full checklist: [docs/troubleshooting.md](./docs/troubleshooting.md).

## APIs: v1 vs v2

* v1: cluster-scoped legacy (`*.crossplane.io/v1alpha1`), no namespace.
* v2: namespaced (`.m.crossplane.io/v1beta1`, `namespace:`-scoped),
  `DeploymentRuntimeConfig`, universal compositions, MRDs.
* New resources: v2. Existing v1 keeps working. Controllers often run both
  scopes side by side.

## Standards

* Index of all norms + enforcement: `docs/standards/README.md`.
* Provider README shape: `docs/standards/readme-standard.md`.
* Platform floor: `docs/standards/platform.md`.
* CI templates: `docs/templates/` (CI validates, Release publishes).
* Compliance source of truth: `scripts/audit_standards.sh`.
* History moved to: `docs/maintenance-history.md`.

# Provider README Template

> Skeleton implementing the canonical
> [README standard](../docs/standards/readme-standard.md) — section order,
> badges, and registry rules. Where they differ, the standards doc wins.
> Platform floor (Crossplane `>= v2.5`):
> [docs/standards/platform.md](../docs/standards/platform.md).
> Delete this notice and replace every `provider-xxx` / `[bracketed]`
> placeholder when scaffolding a new provider.

```markdown
# provider-xxx

[![CI](https://img.shields.io/github/actions/workflow/status/rossigee/provider-xxx/ci.yml?branch=master)][build]
[![Version](https://img.shields.io/github/v/release/rossigee/provider-xxx)][releases]
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[build]: https://github.com/rossigee/provider-xxx/actions/workflows/ci.yml
[releases]: https://github.com/rossigee/provider-xxx/releases

[One paragraph: what this provider manages, via which external service API.]

## Container Registry

- **Primary**: `ghcr.io/rossigee/provider-xxx:vX.Y.Z`

## Features

- [Resource types managed]
- [Key integrations]

## Getting Started

### Prerequisites

- Kubernetes cluster with Crossplane `>= v2.5`
- Credentials for [external-service]

### Installation

```bash
kubectl crossplane install provider ghcr.io/rossigee/provider-xxx:vX.Y.Z
```

### Configuration

Create a secret with your credentials:

```bash
kubectl create secret generic xxx-credentials \
  --from-literal=KEY=value \
  -n crossplane-system
```

Then a ProviderConfig referencing it (see `examples/`).

## Usage

```yaml
# Minimal managed-resource example (v2 namespaced API shown)
apiVersion: xxx.m.crossplane.io/v1beta1
kind: Xxx
metadata:
  name: example
  namespace: default
spec:
  forProvider:
    name: example
  providerConfigRef:
    name: default
  deletionPolicy: Delete
```

Full examples live in `examples/`.

## Resource Types

| Resource | API version | Description |
|----------|-------------|-------------|
| Xxx | xxx.m.crossplane.io/v1beta1 | [What it manages] |

## Development

```bash
make generate   # CRDs
make build      # binary + local image
make test       # unit tests
make lint       # golangci-lint via rossigee/build
```

## Contributing

Issues and PRs go to `github.com/rossigee/provider-xxx` (not the meta-repo).
Build and CI follow the shared standards in `docs/`.

## License

provider-xxx is under the Apache 2.0 license.
```

## After scaffolding

1. Fill in every placeholder; pin the real published tag in Container
   Registry + Installation (they must match).
2. Verify the 6 machine-audited headings exist verbatim: `Container
   Registry`, `Getting Started`, `Resource Types`, `Development`,
   `Contributing`, `License` (`scripts/audit_standards.sh` checks these).
3. Match the `licenses` OCI label in the Dockerfile to the License section.
4. Delete this "After scaffolding" section.

## Naming Conventions

- Title: `# provider-xxx` (lowercase repo name, e.g. `# provider-vault`)
- Badge links: `rossigee/provider-xxx` (lowercase, hyphens)
- Registry: `ghcr.io/rossigee/provider-xxx:vX.Y.Z` (fully qualified)

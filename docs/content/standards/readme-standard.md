---
title: Readme standard
description: Crossplane provider documentation
---

# Crossplane Provider README Standard

## Purpose

This document defines the required structure and content for all Crossplane
provider README files in this repository. A blank skeleton implementing it
lives at `template/README.md`.

## Required elements

All provider READMEs MUST contain these 10 elements: 2 header elements plus
8 `##` sections. Use this order for new READMEs; existing READMEs are
compliant on content even if section order differs (e.g. `provider-btcpay`
puts Container Registry before Overview).

Of the 8 sections, 6 are machine-audited by `scripts/audit_standards.sh`
(marked 🤖 below — a missing heading is a `[PARTIAL] readme sections` finding).
Overview, Features, and Usage are required but checked by human review only.

### Header

#### 1. Title + Badges
```markdown
# provider-name

[![CI](https://img.shields.io/github/actions/workflow/status/rossigee/provider-xxx/ci.yml?branch=master)][build]
[![Version](https://img.shields.io/github/v/release/rossigee/provider-xxx)][releases]
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[build]: https://github.com/rossigee/provider-xxx/actions/workflows/ci.yml
[releases]: https://github.com/rossigee/provider-xxx/releases
```

Badge requirements:

| Badge | Required | Source |
|-------|----------|--------|
| CI/Build | Yes | GitHub Actions workflow |
| Version | Yes | GitHub releases |
| License | Yes | shields.io (match the License section) |

### Sections

#### 2. Overview
Brief 1-3 sentence description of what the provider does. (Human-reviewed.)

#### 3. 🤖 Container Registry
```markdown
## Container Registry

- **Primary**: `ghcr.io/rossigee/provider-xxx:vX.Y.Z`
```

The `ghcr.io/rossigee` image is the required primary registry (fully
qualified — Crossplane v2 has no default registry). Document mirror
registries (Harbor, Upbound) **only if the provider actually publishes to
them**; never list unconfigured registries.

#### 4. Features
Bullet list of key capabilities:
- Resource types managed
- Key integrations
- Enterprise features (if applicable)

(Human-reviewed.)

#### 5. 🤖 Getting Started
##### Prerequisites
- Kubernetes with Crossplane `>= v2.5` (see `platform.md`)
- Target service credentials

##### Installation
```bash
kubectl crossplane install provider ghcr.io/rossigee/provider-xxx:vX.Y.Z
```

##### Configuration
- Create secret with credentials
- Create ProviderConfig manifest
- Document both v1 (cluster-scoped) and v2 (namespaced) API variants where
  both exist

#### 6. Usage
Example manifests for primary resource types. Point at `examples/` for the
full set. (Human-reviewed.)

#### 7. 🤖 Resource Types
Table or list of CRDs:
- Resource name
- API version (v1alpha1/v1beta1)
- Brief description

#### 8. 🤖 Development
```bash
# Generate CRDs
make generate

# Build
make build

# Test
make test

# Lint
make lint
```

#### 9. 🤖 Contributing
Link to CONTRIBUTING.md or similar guidelines (issues/PRs go to the
provider's own repo, not the meta-repo).

#### 10. 🤖 License
```markdown
## License

provider-xxx is under the Apache 2.0 license.
```

Default is Apache-2.0. Exceptions must state the real license here **and**
use the matching SPDX identifier in the Dockerfile
`org.opencontainers.image.licenses` label (e.g. `provider-minio` is AGPL —
see `CONTRIBUTING.md` license-mix note).

## Examples

See `provider-btcpay/README.md` for a reference implementation matching this
standard on content.

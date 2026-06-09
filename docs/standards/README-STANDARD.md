# Crossplane Provider README Standard

## Purpose

This document defines the required structure and content for all Crossplane provider README files in this repository.

## Required Structure

All provider READMEs MUST contain these sections in order:

### 1. Title + Badges
```markdown
# provider-name

[![CI](https://img.shields.io/github/actions/workflow/status/rossigee/provider-xxx/ci.yml?branch=master)][build]
[![Version](https://img.shields.io/github/v/release/rossigee/provider-xxx)][releases]
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[build]: https://github.com/rossigee/provider-xxx/actions/workflows/ci.yml
[releases]: https://github.com/rossigee/provider-xxx/releases
```

### 2. Overview
Brief 1-3 sentence description of what the provider does.

### 3. Container Registry
```markdown
## Container Registry

- **Primary**: `ghcr.io/rossigee/provider-xxx:vX.Y.Z`
```

### 4. Features
Bullet list of key capabilities:
- Resource types managed
- Key integrations
- Enterprise features (if applicable)

### 5. Getting Started
#### Prerequisites
- Kubernetes with Crossplane installed
- Target service credentials

#### Installation
```bash
kubectl crossplane install provider ghcr.io/rossigee/provider-xxx:vX.Y.Z
```

#### Configuration
- Create secret with credentials
- Create ProviderConfig manifest

### 6. Usage
Example manifests for primary resource types.

### 7. Resource Types
Table or list of CRDs:
- Resource name
- API version (v1alpha1/v1beta1)
- Brief description

### 8. Development
```bash
# Build
make build

# Test
make test

# Lint
make lint

# Generate
make generate
```

### 9. Contributing
Link to CONTRIBUTING.md or similar guidelines.

### 10. License
```markdown
## License

provider-xxx is under the Apache 2.0 license.
```

## Badge Requirements

| Badge | Required | Source |
|-------|----------|--------|
| CI/Build | Yes | GitHub Actions workflow |
| Version | Yes | GitHub releases |
| License | Yes | shields.io |

## Registry References

- MUST use `ghcr.io/rossigee/provider-*` as primary
- MUST include all three registry options:
  - Primary: `ghcr.io/rossigee/provider-*`
  - Harbor: Available via environment configuration
  - Upbound: Available via environment configuration

## Examples

See `provider-btcpay/README.md` for a reference implementation matching this standard.
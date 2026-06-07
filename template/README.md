# Provider README Template

## Standard Header Structure

```
# Provider [Name]

[![Build](https://github.com/rossigee/provider-NAME/actions/workflows/ci.yml/badge.svg)](https://github.com/rossigee/provider-NAME/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Brief description of what this provider does and what Crossplane version it supports.
```

## Required Sections

1. **Title** - `# Provider [Name]`
2. **Badges** - CI build status + License
3. **Overview** - One paragraph describing the provider
4. **Features** - Bulleted list of key capabilities
5. **Quick Start** - Installation steps
6. **Configuration** - Provider config setup
7. **Examples** - Sample resource manifests
8. **Development** - Build/test instructions

## Example Sections

```markdown
## Overview

[Provider-name] is a [Crossplane](https://crossplane.io/) provider that enables
infrastructure management for [external-service] through Kubernetes custom resources.

## Features

- Feature 1
- Feature 2
- Feature 3

## Quick Start

### Prerequisites

- Kubernetes cluster with Crossplane installed
- Credentials for [external-service]

### Installation

```bash
# Install provider
kubectl apply -f provider.yaml
```

## Configuration

Create a ProviderConfig to configure credentials.

## Examples

Example resource manifests in `examples/` directory.

## Development

```bash
# Build
make build

# Test
make test
```

## License

Apache 2.0
```

## Naming Conventions

- Title: `# Provider [Name]` (e.g., "Provider Vault", not "provider-vault")
- Badge link: `rossigee/provider-NAME` (lowercase, hyphens)
- Registry: `ghcr.io/rossigee/provider-NAME`

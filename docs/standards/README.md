---
title: Standards Index
description: All normative standards for Crossplane providers in this meta-repo
---

# Standards Index

All normative standards for providers in this meta-repo. Compliance source of
truth is `scripts/audit_standards.sh` (ground-truth scan, not hand-maintained
tables); live status is rendered in `docs/index.md`.

| Standard | File | Enforced by |
|----------|------|-------------|
| Platform baseline (Crossplane `>= v2.5`, runtime/CLI/Go/lint pins) | `platform.md` | `audit_standards.sh` (runtime, fork, CLI, Go) |
| Provider README shape (10 elements, 6 machine-audited) | `readme-standard.md` | `audit_standards.sh` (6 headings); human review (rest) |
| New-provider `.gitignore` | `standard-gitignore.txt` | human review on new-provider PRs |
| CI/CD workflows (CI validates, Release publishes) + lint config | `../templates/` | `audit_standards.sh` (workflows, dependabot) |
| OCI image labels (7 static + dynamic) | `../templates/OCI-LABELS-GUIDE.md` (+ `generate-oci-labels.sh`) | `audit_standards.sh` (static count) |
| Package conventions (`crossplane.yaml`, ENTRYPOINT, cert env vars) | `../troubleshooting.md` | `audit_standards.sh` (filename, ENTRYPOINT) |
| Native-only mandate (no Terraform/Upjet) | `AGENTS.md` + `CONTRIBUTING.md` | human review (reject terraform PRs) |
| API versioning (v1 cluster-scoped vs v2 namespaced) | `AGENTS.md` | `audit_standards.sh` (v1beta1 controllers) |

Naming: standards files are lowercase kebab-case. Scaffolding skeleton for new
provider READMEs: `template/README.md` (implements `readme-standard.md`).

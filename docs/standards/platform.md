# Platform Baseline

Minimum supported platform for all providers in this repository.

| Component | Standard | Source |
|-----------|----------|--------|
| Crossplane core | `>= v2.5` | namespaced (`.m.`) APIs, `DeploymentRuntimeConfig` |
| crossplane-runtime/v2 | `v2.5.0` via `github.com/rossigee/crossplane-runtime` fork (`replace` directive) | fork carries events fix below |
| crossplane CLI | `v2.5.0` from `cli.crossplane.io` | matches `rossigee/build` `makelib/k8s_tools.mk` |
| Go | `1.27.1` | `go.mod`, `Makefile GO_REQUIRED_VERSION`, `ci.yml GO_VERSION` |
| golangci-lint | `2.13.2` | `.golangci.yml` + `Makefile GOLANGCILINT_VERSION` |
| Build submodule | `https://github.com/rossigee/build` @ `rossigee-lint-fixes` | audited by `scripts/audit_standards.sh` |
| pre-commit / hadolint | `v6.0.0` / `v2.12.0` | CI templates |

## Why v2.5 (not older)

All 20 providers build on `crossplane-runtime/v2 v2.5.0` via the
`rossigee/crossplane-runtime` fork because upstream has not yet merged the
migration from the deprecated `record.EventRecorder` (core `v1/Event`) to
`events.EventRecorder` (`events.k8s.io/v1`), required for newer
controller-runtime / client-go compatibility. Running these providers against
Crossplane cores `< v2.5` is unsupported. Legacy cluster-scoped (v1) APIs keep
working where present, but namespaced `.m.` APIs assume v2.5 behavior.

Related upstream work:

1. [crossplane-runtime#1057](https://github.com/crossplane/crossplane-runtime/issues/1057)
   — `APIRecorder uses deprecated record.EventRecorder and drops filterFns`.
   Defines the four defects: deprecated recorder, `WithAnnotations` drops
   `filterFns`, wrong `FilterFn` godoc, empty action string rejected by
   `events.k8s.io/v1`.
2. [crossplane-runtime#1052](https://github.com/crossplane/crossplane-runtime/pull/1052)
   (`rossigee:events-recorder-fixes` → `crossplane:main`, open) — the fix
   (commits `Migrate event package from record.EventRecorder to
   events.EventRecorder` + `test(event): assert action string in Eventf call`).
   Self-described as prerequisite for `crossplane#7643`; unblocks removing the
   `rossigee/crossplane-runtime` fork dependency once merged.
3. [crossplane#7152](https://github.com/crossplane/crossplane/issues/7152) —
   upstream tracking issue for migrating to controller-runtime's new events API.
4. [crossplane#7469](https://github.com/crossplane/crossplane/issues/7469)
   (closed, fixed by
   [#7770](https://github.com/crossplane/crossplane/pull/7770)) — RBAC-manager
   companion fix: provider ClusterRoles must grant `events.k8s.io/v1`, not just
   core `events`. Required at runtime once providers emit via the new API.
5. [crossplane#7643](https://github.com/crossplane/crossplane/pull/7643) —
   downstream core work blocked on `#1052` (per the PR description).

Until upstream merges `#1052`, keep the fork `replace` directive in every
provider's `go.mod` and treat the fork's `events-recorder-fixes` / `k8s-0.36.3`
branches as the org baseline; track upstream security backports into the fork
periodically so the gap does not reopen.

## Enforcement

`scripts/audit_standards.sh` checks `go.mod` runtime version and CLI version
alongside Go/lint/build/registry. Re-run after bumps:

```bash
./scripts/audit_standards.sh
./scripts/audit_standards.sh --format markdown
```

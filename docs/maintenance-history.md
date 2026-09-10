# Maintenance History

Archived incident/fix narratives moved out of `AGENTS.md` during the
pre-announcement slim-down (2026-09-10). Ground truth for current compliance is
`scripts/audit_standards.sh` + `docs/index.md`, not this file.

## Build system standardization (2025-08-04)

All providers moved from `github.com/crossplane/build` to
`github.com/rossigee/build` (missing make targets upstream). Side fixes:
removed incompatible `.golangci.yml` files, fixed Go version parsing, updated
modules. `make reviewable` verified on updated providers
(gitea, signoz, openstack, http, vault).

## Tag conflict resolution (2025-08-14)

CI and Release workflows both published images → `latest` and version tags
diverged. Adopted "CI Builds, Release Publishes": CI validates only, Release is
the single publishing source of truth. Templates in `docs/templates/`
(`ci-template.yml`, `release-template.yml`, `README.md`). First applied to
provider-mailgun; version/latest tags verified identical via digest comparison.

## Repository cleanup (2025-07-27)

Removed `00-archive/`, `_output/`, `bin/`, coverage files, orphaned `.xpkg`
files. Official packages kept only in per-provider `package/` directories.

## v2 migration (completed 2025-09-06)

provider-minio and provider-mailgun gained dual-scope support
(cluster-scoped v1 + namespaced v1beta1 `.m.` APIs). minio: Bucket, User,
Policy, ServiceAccount. mailgun: Domain, MailingList, Route, Webhook,
Template, SMTPCredential, Bounce (133+ tests passing).

## OCI labels + README compliance (fixed 2026-08-10, 20/20)

Two audit rounds: 7 providers at 0/7 labels got full sets; 8 more were missing
`url`/`documentation` (vault also `licenses`/`source`). README pass fixed
heading mismatches plus real inaccuracies: backblaze's claimed (nonexistent)
`.m.` API, docker's overstated dual-scope claim (only `Container` has both
controllers; `Volume`/`Network`/`ComposeStack` have v1beta1 types but no
controller — Tier 2 backlog), libvirt's single-scope reality (namespaced only),
gitea's stale "no controllers" banner. Two orphaned Dockerfiles flagged, left
untouched: `provider-btcpay/cluster/images/provider-plausible/Dockerfile`,
`provider-keycloak/cluster/images/provider-template/Dockerfile`.

## provider-discord v1beta1 controllers (fixed 2026-08-10)

v1beta1 types existed for all 9 resources but `register.go` stubs were empty
and no controllers were wired (`// Planned for v2 migration`). Filled in all 9
`register.go` files, added namespaced controllers alongside v1alpha1 —
true dual-scope. New v1beta1 packages have no dedicated tests yet (Tier 3).

## provider-gitea RepositoryKey/RepositorySecret (fixed 2026-08-10)

Found while rewriting the README: both controllers were written with working
`Setup()` but never wired into `controller.go`. Wired in; `go build`,
`make lint`, `go test ./internal/controller/...` pass. Gitea: 6 working
controllers of 22 defined types.

## Build submodule deviations (resolved 2026-08-10, refreshed 2026-09-08)

All 20 on `rossigee-lint-fixes @ e5bf20a` (Go 1.27.1, lint 2.13.2, runtime
v2.5.0). Notable: provider-openstack was pinned to an orphaned commit on a
force-pushed `main` (unfetchable on fresh clone) — realigned; vault realigned
from `main@080d633`; keycloak SSH→HTTPS; minio trailing `.git` removed.

## Runtime unification (2026-08-10 fix, 2026-09-08 unified)

`v2.4.0-rc.0` proved chronologically *older* than `v2.3.3` and lacked a
GHSA-backported xpkg TOCTOU fix + CVE bumps. Five providers on the rc pulled
via the `rossigee/crossplane-runtime` fork predating the backports. Fixed by
merging upstream security fixes into the fork (`events-recorder-fixes`) and
bumping all five; 2026-09-08 unified all 20 on `v2.5.0` via the fork. The fork
remains the org baseline until upstream merges
[crossplane-runtime#1052](https://github.com/crossplane/crossplane-runtime/pull/1052);
see `docs/standards/platform.md`.

## provider-openstack runtime v1/v2 conflict (diagnosed, not fixed)

`apis/blockstorage/v1alpha1` (upjet-generated) imports legacy
`crossplane-runtime` (caps at controller-runtime `v0.19.0`) alongside
`crossplane-runtime/v2` (`v0.24.1` via MVS) → `Apply` method compile error on
`client.SubResourceWriter`. No version bump fixes it; needs upjet codegen
migration or project-wide controller-runtime downgrade. Stale gitignored
`vendor/` (2026-07-28) also out of sync. Flagged as separate pre-existing bug.

## Pre-existing lint fixes (2026-08-10)

backblaze `cmd/provider/main.go:52` (unchecked `os.Setenv`), keycloak
`internal/controller/role/role_test.go:40` (dead `resetClientSecretFn`).

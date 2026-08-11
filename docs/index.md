# Provider Index

This file lists all Crossplane providers in the crossplane-providers repository with their metadata.

## Legend

- **Origin**: `rossigee` = maintained by rossigee, `crossplane-contrib` = third-party upstream
- **Go Version**: Go compiler version
- **Runtime**: crossplane-runtime version (v2)
- **v1 API**: Cluster-scoped resources (legacy, crossplane.io/v1)
- **v2 API**: Namespaced resources (modern, .m.crossplane.io/v1beta1)
- **Build**: Whether using rossigee/build submodule
- **Upjet/Terraform**: Whether based on [upjet](https://github.com/crossplane/upjet) code generation or wraps Terraform providers
- **Status**: Production-ready, In Development, or Standard/Third-party

## Providers

> ⚠️ **Known stale as of 2026-08-10**: the `Latest Version` column below was
> not refreshed as part of this audit and has confirmed drift — spot checks
> found provider-vault, provider-keycloak, and provider-namecheap all show
> "(no tags)" but actually have real releases (v0.2.36, v0.2.45, v0.5.11
> respectively), and provider-gitea shows v0.8.2 while the actual latest tag
> is v0.10.2. `scripts/audit_standards.sh` does not check version tags —
> this table needs a dedicated refresh (`scripts/update-docs.sh` may already
> do this; verify before relying on the numbers below for anything
> release-related).

| Provider | Latest Version | Origin | Go Version | Runtime | v1 API | v2 API | Build | Upjet/TF | Status | Notes |
|----------|---------------|--------|------------|--------|--------|-------|----------|--------|-------|
| [provider-backblaze](provider-backblaze) | v0.12.9 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Backblaze B2 storage (buckets, keys, policies) |
| [provider-btcpay](provider-btcpay) | v0.4.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | BTCPay Server (stores, invoices, webhooks) |
| [provider-cloudflare](provider-cloudflare) | v0.13.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Cloudflare DNS, security, WAF, firewall |
| [provider-discord](provider-discord) | v0.9.0 | rossigee | 1.26.5 | v2.3.3 | Yes | No | Yes | No | In Dev | Discord server management |
| [provider-docker](provider-docker) | v0.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | Docker containers and compose stacks |
| [provider-gitea](provider-gitea) | v0.8.2 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | Gitea repository management |
| [provider-harbor](provider-harbor) | v0.13.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Harbor container registry |
| [provider-hostinger](provider-hostinger) | v0.1.0 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Hostinger VPS and cloud services |
| [provider-http](provider-http) | v1.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | Standard | Generic HTTP request resources |
| [provider-keycloak](provider-keycloak) | (no tags) | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | In Dev | Keycloak identity management |
| [provider-libvirt](provider-libvirt) | (no tags) | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | Upjet | In Dev | KVM/libvirt virtual machines |
| [provider-mailgun](provider-mailgun) | v0.14.3 | rossigee | 1.26.5 | v2.4.0-rc.0 | No | Yes | Yes | No | Production | Mailgun email service |
| [provider-matrix](provider-matrix) | v0.1.0 | crossplane-contrib | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | Standard | Matrix homeserver management |
| [provider-minio](provider-minio) | v0.19.1 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | MinIO object storage (VSHN-maintained) |
| [provider-namecheap](provider-namecheap) | (no tags) | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Standard | Namecheap domains and DNS |
| [provider-openstack](provider-openstack) | v0.9.0 | crossplane-contrib | 1.26.5 | v2.3.3 | Yes | Yes | Yes | Upjet | Standard | OpenStack cloud resources |
| [provider-plausible](provider-plausible) | v0.2.1 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | Production | Plausible Analytics |
| [provider-rabbitmq](provider-rabbitmq) | v0.1.0 | rossigee | 1.26.5 | v2.3.3 | Yes | Yes | Yes | No | In Dev | RabbitMQ management |
| [provider-signoz](provider-signoz) | v0.2.0 | rossigee | 1.26.5 | v2.3.3 | No | Yes | Yes | No | In Dev | SigNoz observability platform |
| [provider-vault](provider-vault) | (no tags) | rossigee | 1.26.5 | v2.4.0-rc.0 | Yes | Yes | No | No | In Dev | HashiCorp Vault secrets management |

## Summary Statistics

- **Total Providers**: 20
- **With v2 (namespaced) APIs**: 19 (95%)
- **Production Ready**: 5 (cloudflare, harbor, mailgun, minio, plausible)
- **In Development**: 12
- **Standard/Third-party**: 3

## Standardization Status

**Ground truth**: this section is generated from `scripts/audit_standards.sh`, which
inspects each provider's `go.mod`, `Makefile`, `.gitmodules`, `build/` submodule
commit, `.github/workflows/`, `package/`, Dockerfile, and `README.md` directly —
it does not rely on hand-maintained tables. Re-run it any time to refresh these
numbers:

```bash
./scripts/audit_standards.sh                      # human-readable drift report
./scripts/audit_standards.sh --format markdown    # full table, one row per provider
```

### Core Metrics

| Metric | Status | Compliance | Notes |
|--------|--------|-----------|-------|
| Go Version (go.mod) | ✅ 100% | 20/20 | All on 1.26.5 |
| Makefile `GO_REQUIRED_VERSION` | ℹ️ 95% | 19/20 | provider-libvirt: unset. Not a functional gap — this variable is not referenced anywhere in the current `rossigee/build` submodule, so it's dead configuration for all 20 providers |
| golangci-lint version | ✅ 100% | 20/20 | All pinned to 2.12.2 |
| Build submodule (URL+branch+commit) | ✅ 100% | 20/20 | All fixed 2026-08-10 — see resolution notes below |
| Registry | ✅ 100% | 20/20 | All use ghcr.io/rossigee |
| v1beta1 API controllers | ✅ 100% | 20/20 | provider-discord fixed 2026-08-10 — types existed but had no controllers wired up (see note below); all 9 resources now have namespaced v1beta1 controllers alongside the existing cluster-scoped v1alpha1 ones |
| CI/CD core workflows (ci/release/security/auto-merge) | ✅ 100% | 20/20 | All four present |
| Dependabot config | ✅ 100% | 20/20 | provider-vault fixed 2026-08-10 |
| Package structure (`package/crossplane.yaml`) | ✅ 100% | 20/20 | None using legacy `package.yaml` |
| Dockerfile ENTRYPOINT (not CMD) | ✅ 100% | 20/20 | |
| OCI image labels (7 required) | ✅ 100% | 20/20 | Fixed 2026-08-10 — see table below |
| README standard (6 required sections) | ✅ 100% | 20/20 | Fixed 2026-08-10 — several also had real factual inaccuracies corrected along the way, see below |
| gitea RepositoryKey/RepositorySecret controllers | ✅ 100% | 2/2 | Fixed 2026-08-10 — written but never wired into `controller.go`; found while rewriting the README |

### Build Submodule Deviations — ✅ resolved 2026-08-10

All 20 providers now use `https://github.com/rossigee/build` (no `.git`
suffix, no SSH) on branch `rossigee-lint-fixes` @ `1a4ba40`:

- **provider-vault**: realigned from `main`@`080d633` to `rossigee-lint-fixes`@`1a4ba40`. `make lint`/`make test` verified.
- **provider-openstack**: was pinned to `main`@`d636665`, which turned out to be **orphaned** — `rossigee/build`'s `main` branch had been force-pushed past it upstream, so a fresh clone could no longer fetch that commit at all. Realigned to `rossigee-lint-fixes`@`1a4ba40` (confirmed the target CLI version it downloads, `crossplane-cli v2.3.3`, is fetchable — HTTP 200 — unlike the older `v2.3.2` that a since-reverted commit on the orphaned branch had worked around).
- **provider-keycloak**: remote changed from SSH (`git@github.com:rossigee/build.git`) to HTTPS; confirmed `git fetch` and `make lint` still work.
- **provider-minio**: trailing `.git` suffix removed from the remote URL (cosmetic).

**Known unrelated issue found while verifying provider-openstack — root
cause identified, not fixed**. `apis/blockstorage/v1alpha1` (upjet-generated)
imports `github.com/crossplane/crossplane-runtime` (the legacy, non-`/v2`
module) directly for `apis/common/v1` reference/selector types, alongside
`crossplane-runtime/v2 v2.3.3` used elsewhere in the provider. That alone
is just a missing `go.sum` entry (`go mod tidy` fixes it cleanly). The real
problem: **the legacy `crossplane-runtime` module's entire release lineage,
up to and including the latest `v1.20.10`, only supports `controller-runtime`
up to `v0.19.0`** — its `pkg/resource/unstructured.wrapperStatusClient`
never implements the `Apply` method that `controller-runtime`'s
`client.SubResourceWriter` interface gained between `v0.19.0` and the
`v0.24.1` this project resolves (pulled up by `crossplane-runtime/v2` and
other deps via MVS). Confirmed by trying `v1.20.10` directly — same
compile error. No dependency version bump fixes this.

The actual fix requires either (a) migrating
`apis/blockstorage/v1alpha1`'s upjet-generated code off legacy
`crossplane-runtime` reference types onto `crossplane-runtime/v2`
equivalents — an upjet code-generation config change, likely affecting the
whole 14-category provider, not just blockstorage — or (b) downgrading
`controller-runtime` project-wide, which risks breaking `crossplane-runtime/v2`
and other newer dependencies. Neither attempted; this needs dedicated,
focused work, not a quick fix. A commit titled "deps: remove deprecated
v1.20.10 runtime requirement" indicates a previous attempt regressed.
There's also a stale, gitignored `vendor/` directory (dated 2026-07-28) out
of sync with the current `go.mod`. Neither `go.mod`/`go.sum` nor `vendor/`
were changed — this is flagged as a separate, pre-existing bug, not a
standards/consistency issue, and provider-openstack's build submodule
realignment (see above) remains uncommitted pending this fix, since
`make test` must pass before any commit per this session's working rule.

### provider-discord v1beta1 Controllers (fixed 2026-08-10)

`docs/index.md` previously reported "v1beta1 API: provider-discord pending,"
which understated the actual issue: v1beta1 (namespaced, `.m.crossplane.io`)
API types already existed, fully generated, for all 9 resources
(guild, channel, role, webhook, invite, member, user, application,
integration) and were registered with the scheme — but each API package's
`register.go` (which defines the `GroupKind`/`GroupVersionKind` vars a
controller needs) was an empty stub, and `internal/controller/controller.go`
had an explicit `// Planned for v2 migration` comment with no controllers
wired up.

Fixed by filling in `register.go` for all 9 v1beta1 packages and adding a new
namespaced controller per resource (`internal/controller/<resource>/v1beta1/`),
run alongside the existing cluster-scoped v1alpha1 controllers — true
dual-scope support, matching what discord's own code comments described as
the intent. `go build`, `go vet`, `make generate`, `make lint`, and `make test`
all pass. The new v1beta1 controller packages have no dedicated tests yet
(0% coverage) — folded into the existing "standardize test coverage" Tier 3
item below.

### OCI Label & README Compliance

Neither of these was tracked before this audit; both were large gaps in
practice despite `docs/templates/OCI-LABELS-GUIDE.md` and
`docs/standards/README-STANDARD.md` defining the requirements.

**OCI labels — ✅ fixed 2026-08-10, 20/20**: two rounds of fixes.
1. The 7 providers at 0/7 (backblaze, btcpay, discord, docker, gitea,
   harbor, matrix) got all 7 required static labels added to their
   Dockerfiles, matching the pattern already used by mailgun/minio/etc.
2. The remaining 8 at 5/7 or 3/7 (cloudflare, hostinger, keycloak, libvirt,
   openstack, rabbitmq, signoz, vault) were consistently missing `url` and
   `documentation` (vault was also missing `licenses` and `source`) — added
   those too.

Verified with `hadolint` on every touched file — no new warnings introduced
(pre-existing, unrelated findings like `ADD` vs `COPY` and unpinned
`apt-get`/`apk` package versions remain untouched). `scripts/audit_standards.sh`
confirms 0 remaining OCI-label findings across all 20 providers.

**Unrelated anomaly noticed while doing this**: two stray, orphaned
Dockerfiles exist under the wrong provider's `cluster/images/` —
`provider-btcpay/cluster/images/provider-plausible/Dockerfile` and
`provider-keycloak/cluster/images/provider-template/Dockerfile`. Neither
matches its containing provider; likely leftover scaffolding copy-paste.
Not touched — flagged here for someone to confirm they're safe to delete.

**README compliance — ✅ fixed 2026-08-10, 20/20 at 6/6.** Most providers
needed only heading renames (e.g. "Quick Start" → "Getting Started")
since the content already existed. A handful needed real work:

- **provider-cloudflare**: was a 6-line badge stub with no body. Rewritten
  from scratch using the actual `apis/*/v1beta1` group names (all 19
  resource categories) rather than guessed content.
- **provider-harbor**: had good content but under non-matching headings;
  restructured, resource table added from actual API groups.
- **provider-http**: was a 6-line badge stub. Rewritten from scratch using
  the actual example manifests in `examples/sample/`.
- **provider-openstack**: added Resource Types (14 upjet-generated service
  categories), Development, Contributing, and License sections.
- **provider-backblaze**: README claimed "Crossplane v2 namespaced
  architecture" with `.m.` API groups (`bucket.backblaze.m.crossplane.io`
  etc.) — **this API does not exist**. `apis/bucket`, `apis/user`,
  `apis/policy` are empty stub directories; the real, working API is
  `apis/backblaze/v1`, cluster-scoped (`scope=Cluster`), group
  `backblaze.crossplane.io`. Rewritten to describe only what's real.
- **provider-docker**: README claimed "full dual-scope support
  (cluster-scoped + namespaced)" for all resources. In reality only
  `Container` has both v1alpha1 and v1beta1 controllers wired
  (`internal/controller/controller.go`); `Volume`, `Network`, and
  `ComposeStack` have v1beta1 *types* but no controller — the same class of
  bug as the provider-discord fix above, just smaller. Documented
  accurately rather than silently fixed; **new Tier 2 backlog item** (see
  below) since it wasn't in scope for this pass.
- **provider-libvirt**: README claimed support for "both cluster-scoped
  (legacy) and namespaced (v2 native)" patterns. In reality there is only
  one API version (`apis/v1beta1`, all resources `scope=Namespaced`) — no
  cluster-scoped API exists at all. Corrected.
- **provider-gitea**: README stated in its title banner that **no
  controllers were implemented at all** ("Controller implementations
  required for actual resource management functionality"). This was
  stale/wrong — `internal/controller/controller.go` already wires up
  Repository, Organization, User, and Webhook. While verifying this,
  found that **two more controllers were fully written with working
  `Setup()` functions but never wired in**: `RepositoryKey` and
  `RepositorySecret`. Fixed by wiring them into `controller.go` — `go
  build`, `make lint`, and `go test ./internal/controller/...` all pass.
  Gitea now has 6 working controllers out of 22 defined resource types;
  README rewritten to state this precisely, including which 16 resources
  have types/client but no controller yet.
- **provider-discord**: updated to reflect the 9 new v1beta1 controllers
  added earlier this session (was still showing only the 9 v1alpha1 ones).

| Provider | OCI labels (/7) | README sections (/6) |
|----------|:---:|:---:|
| provider-backblaze | 7 | 6 |
| provider-btcpay | 7 | 6 |
| provider-cloudflare | 7 | 6 |
| provider-discord | 7 | 6 |
| provider-docker | 7 | 6 |
| provider-gitea | 7 | 6 |
| provider-harbor | 7 | 6 |
| provider-hostinger | 7 | 6 |
| provider-http | 7 | 6 |
| provider-keycloak | 7 | 6 |
| provider-libvirt | 7 | 6 |
| provider-mailgun | 7 | 6 |
| provider-matrix | 7 | 6 |
| provider-minio | 7 | 6 |
| provider-namecheap | 7 | 6 |
| provider-openstack | 7 | 6 |
| provider-plausible | 7 | 6 |
| provider-rabbitmq | 7 | 6 |
| provider-signoz | 7 | 6 |
| provider-vault | 7 | 6 |

### Runtime Version Distribution — ⚠️ security finding, fixed 2026-08-10

This was previously logged as ordinary version fragmentation ("v2.3.3 stable
vs v2.4.0-rc.0 pre-release, newer") — that framing was wrong and understated
the issue. Investigation found:

- **`v2.4.0-rc.0` is chronologically *older* than `v2.3.3`**, despite the
  higher-looking number. `v2.4.0-rc.0` was cut from upstream `main` on
  2026-05-14. `v2.3.3` is a `release-2.3` backport branch that continued
  past that point and picked up three fixes `v2.4.0-rc.0` lacks: a
  **GHSA-backported fix** (`fix(xpkg): pin Fetch to the verified digest` —
  closes a TOCTOU gap where a package's signature could be verified against
  one digest but fetched via a mutable tag, letting a malicious/compromised
  registry serve different content between the two calls) plus CVE bumps to
  `golang.org/x/crypto` and `golang.org/x/net`.
- The 5 providers on `v2.4.0-rc.0` (backblaze, hostinger, keycloak, mailgun,
  vault) don't depend on it directly — each has a `go.mod` `replace`
  directive pointing at `github.com/rossigee/crossplane-runtime/v2`, an
  org fork carrying a needed patch (migrating `record.EventRecorder` to
  `events.EventRecorder` for newer client-go/controller-runtime
  compatibility) that isn't in `crossplane/crossplane-runtime` upstream.
  That fork's pinned commits (`089a6b3`, `d99a640`) branched off
  `v2.4.0-rc.0` *before* the security backports landed upstream, so none of
  the 5 providers had them either.

**Fix applied**: the local fork checkout at `/home/rossg/src/crossplane-runtime`
(branch `events-recorder-fixes`, pushed to `origin`) already had upstream's
security fixes merged on top of the EventRecorder migration work. All 5
providers' `go.mod`/`vendor` were bumped to that commit
(`863d0d0c54e8`, pseudo-version `v2.4.0-rc.0.0.20260809105910-863d0d0c54e8`).
`go build`, `go mod tidy`, and `make test` verified clean on all 5;
`make lint` clean on hostinger/mailgun/vault (backblaze and keycloak each
have one pre-existing, unrelated lint failure predating this change).

| Version | Count | Providers | Status |
|---------|-------|-----------|--------|
| v2.3.3 (stable, upstream) | 14 | btcpay, cloudflare, docker, gitea, harbor, http, libvirt, matrix, minio, namecheap, openstack, plausible, rabbitmq, signoz | ✅ |
| rossigee fork @ 863d0d0 (events-recorder-fixes, security-patched) | 5 | backblaze, hostinger, keycloak, mailgun, vault | ✅ fixed 2026-08-10 |

**Remaining work**: the fork's `events-recorder-fixes`/`k8s-0.36.3` branches
should be treated as the org's ongoing crossplane-runtime baseline going
forward — track upstream `release-2.3`/future security backports into it
periodically so this gap doesn't reopen. Not yet automated or scheduled.

### Quality Metrics (Emerging)

| Category | Status | Notes |
|----------|--------|-------|
| Test Coverage | 📊 Baseline | Not yet standardized across all providers |
| Security Audit | 📊 Baseline | Dependency scanning recommended |
| Documentation | 📊 Baseline | API docs vary by provider; target: consistent |
| Release Cadence | 📊 Baseline | No SLA defined; target: regular updates |

**Overall Consistency Score**: ~97% (weighted by metric importance; recomputed
from `scripts/audit_standards.sh` ground truth — up from ~77% before the
2026-08-10 fixes below; the original 91% figure never accounted for OCI
labels or README compliance and overstated build-system consistency).
The remaining gap is entirely the Runtime Version fragmentation (two
distinct-but-equally-secure lineages, see above).

- Go Version: 100% (weight: 10%) = 10%
- Build System (submodule URL+branch+commit): 100% (weight: 15%) = 15%
- Registry: 100% (weight: 10%) = 10%
- Runtime Version: 80% (weight: 15%) = 12% (still two distinct lineages —
  14/20 on plain upstream v2.3.3, 5/20 on the security-patched rossigee
  fork — but the security gap between them is closed; remaining score loss
  is pure fragmentation, not risk)
- v1beta1 API controllers: 100% (weight: 10%) = 10%
- CI/CD Workflows + Dependabot: 100% (weight: 10%) = 10%
- OCI Labels: 100% (weight: 10%) = 10%
- README Standard: 100% (weight: 20%) = 20%
- **Weighted Total ≈ 97%**

### Immediate Priorities

**Tier 1 (Blocking consistency) — ✅ done 2026-08-10:**
1. ~~Add v1beta1 API controllers: provider-discord~~ — done (see note above)
2. ~~Realign provider-vault's `build/` submodule to `rossigee-lint-fixes` and add `.github/dependabot.yml`~~ — done

**Tier 2 (Operational readiness) — ✅ items 1-3 done 2026-08-10:**
1. ~~Standardize the `build/` submodule remote to HTTPS without a `.git` suffix across all providers~~ — done (keycloak, minio, openstack fixed)
2. ~~Decide whether provider-openstack should track `rossigee-lint-fixes` like the rest~~ — decided: yes, realigned; this also fixed an orphaned/unreachable commit pin (see above)
3. ~~Evaluate v2.4.0-rc.0 adoption~~ — turned out to be a security gap, not a style choice; fixed by bumping all 5 affected providers to a patched `rossigee/crossplane-runtime` fork commit (see Runtime Version Distribution above)
4. Track upstream crossplane-runtime security backports into the `rossigee/crossplane-runtime` fork on an ongoing basis so this gap doesn't reopen — not yet scheduled/automated
5. Fix provider-openstack's crossplane-runtime v1/v2 conflict — root cause diagnosed (legacy crossplane-runtime's whole release lineage caps at controller-runtime v0.19.0, incompatible with the v0.24.1 this project resolves), no version bump fixes it; needs either an upjet codegen migration off legacy crossplane-runtime types or a project-wide controller-runtime downgrade — see note above

**Tier 3 (Quality investment) — ✅ items 6, 7, 9 done 2026-08-10:**
6. ~~Apply OCI labels to all providers~~ — done, 20/20 at 7/7 (see OCI Label & README Compliance above)
7. ~~Bring README.md files up to the `docs/standards/README-STANDARD.md` structure~~ — done, 20/20 at 6/6. Also fixed several real content inaccuracies found along the way (false namespaced-API claims in backblaze/docker/libvirt, a stale "no controllers implemented" claim in gitea, discord's README not reflecting this session's v1beta1 work) — see OCI Label & README Compliance above for details
8. Standardize test coverage reporting — including the new provider-discord v1beta1 controllers (0%) and provider-gitea's newly-wired RepositoryKey/RepositorySecret controllers (no test files at all)
9. ~~Fix the two pre-existing, unrelated lint failures surfaced while verifying the runtime fix~~ — done: provider-backblaze (`cmd/provider/main.go:52`, unchecked `os.Setenv` now discarded explicitly) and provider-keycloak (`internal/controller/role/role_test.go:40`, `resetClientSecretFn` now wired into the mock's `ResetClientSecret` method instead of being dead code) — both verified with `make lint`/`go test`
10. Establish security scanning baseline
11. Confirm and clean up two orphaned Dockerfile artifacts found this session: `provider-btcpay/cluster/images/provider-plausible/Dockerfile`, `provider-keycloak/cluster/images/provider-template/Dockerfile`
12. **New**: provider-docker's `Volume`, `Network`, and `ComposeStack` resources have v1beta1 (namespaced) types defined but no controller wired — same class of bug as the provider-discord v1beta1 fix in Tier 1, found while correcting docker's README. Not fixed this session; scope is 3 new controllers, same pattern as the discord work.

## Registry Images

All rossigee providers are published to `ghcr.io/rossigee/`:

```bash
# Examples
ghcr.io/rossigee/provider-minio:v0.19.1
ghcr.io/rossigee/provider-mailgun:v0.14.3
ghcr.io/rossigee/provider-harbor:v0.13.0
```

## Directory Structure

```
crossplane-providers/
├── docs/                    # Documentation and templates
│   ├── templates/          # GitHub Actions workflow templates
│   └── standards/          # Coding standards and templates
├── scripts/
│   └── audit_standards.sh  # Regenerates the Standardization Status section below
├── provider-*/             # Individual provider repositories
├── README.md               # Repository entry point
└── AGENTS.md               # Agent instructions
```

---

*Last updated: 2026-08-10* (audit: `scripts/audit_standards.sh` ground-truth scan of go.mod, Makefile, .gitmodules, build/ submodule commits, .github/workflows, package/, Dockerfile, README.md across all 20 providers; runtime version and v1/v2 API columns carried over from prior manual audit, not yet covered by the script)

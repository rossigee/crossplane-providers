# Contributing

This meta-repo tracks shared standards; all provider code lives in the
per-provider repositories (each `provider-*` dir is a git submodule).

## Where to contribute

* **Bug fix / feature in a provider** → open the issue/PR in that provider's
  repo (e.g. `rossigee/provider-minio`), not here.
* **Shared standards, CI templates, docs** → PR here against `docs/`,
  `scripts/`, `template/`.

## New provider checklist

1. Native Crossplane implementations only — no `upjet`, `terraform-plugin-sdk` /
   `framework`, `terraform-provider-*` (see `AGENTS.md` mandate).
2. Platform floor: Crossplane core `>= v2.5`, runtime `v2.5.0` via
   `rossigee/crossplane-runtime` fork — see `docs/standards/platform.md`.
3. Build: `rossigee/build` submodule (`rossigee-lint-fixes`), no local
   `.golangci.yml`. Verify `make lint reviewable test build`.
4. Package: `package/crossplane.yaml` (`kind: Provider`), Dockerfile
   `ENTRYPOINT` (never `CMD`) — see `docs/troubleshooting.md`.
5. README per `docs/standards/readme-standard.md`; CI from `docs/templates/`;
   publish to `ghcr.io/rossigee/` with a fully qualified tag.
6. Register in `.gitmodules`, `docs/index.md`, and `scripts/update-docs.sh`.

## Clone

```bash
git clone https://github.com/rossigee/crossplane-providers.git
cd crossplane-providers
git submodule update --init --recursive
```

(All submodule remotes are HTTPS, so a fresh clone works without SSH keys.)

## License

Meta-repo docs/tooling: Apache-2.0 (see `LICENSE`). Individual providers carry
their own licenses (mostly Apache-2.0; e.g. provider-minio is AGPL) — check the
provider repo before reuse.

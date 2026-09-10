---
title: Troubleshooting
description: Crossplane provider documentation
---

# Troubleshooting

## Critical gotchas

1. **Package file name**: must be `package/crossplane.yaml` (`kind: Provider`),
   never `package/package.yaml`. The build's `--embed-runtime-image` logic greps
   for it; without it the `.xpkg` ships with no runtime image → provider pod
   fails with "no command specified". Fix: `mv package/package.yaml
   package/crossplane.yaml`, rebuild.
2. **Dockerfile**: must use `ENTRYPOINT ["/usr/local/bin/provider"]`, not `CMD`.
   Crossplane passes config via environment, not CLI args.
3. **Cert paths**: never hardcode `/tmp/k8s-webhook-server/serving-certs`; use
   `os.Getenv("WEBHOOK_TLS_CERT_DIR")` (plus `TLS_SERVER_CERTS_DIR`,
   `LEADER_ELECT`) in `cmd/provider/main.go`.
4. **Build submodule**: must be `https://github.com/rossigee/build`
   (`rossigee-lint-fixes` branch). Upstream `crossplane/build` lacks targets.
   After checkout: `git submodule update --init --recursive`. Remove stray
   `.golangci.yml` files (build submodule provides the config).

## Before publishing a provider

```bash
make lint && make reviewable && make test
ls package/crossplane.yaml            # must exist
make xpkg.build
tar -tf _output/xpkg/linux_amd64/provider-*.xpkg | grep manifest.json
kubectl apply -f test-provider.yaml   # non-prod cluster first
```

## Health checks

```bash
kubectl get providerrevisions | grep provider-name
kubectl get pods -n crossplane-system | grep provider-name
kubectl logs -n crossplane-system deployment/provider-name
kubectl describe validatingwebhookconfigurations | grep provider-name
```

## Specific errors

* **"No command specified"**: `.xpkg` missing Docker layers → check
  `package/crossplane.yaml` name/kind, Dockerfile `ENTRYPOINT`, rebuild.
* **TLS/certificate errors**: check `main.go` env vars, webhook cert paths, pod
  env (`kubectl describe pod -n crossplane-system`).
* **"No rule to make target 'lint'"**: wrong build submodule; `git submodule
  sync && git submodule update --init`, remove `.golangci.yml`.
* **"unsupported version of configuration"** (golangci): same — remove local
  config, use build submodule's.
* **Stale `vendor/`**: provider-openstack has a gitignored out-of-sync
  `vendor/`; prefer `go mod tidy` over vendoring except where CI requires it.

## Provider README requirements

Per `docs/standards/readme-standard.md`: Title+Badges, Overview, Container
Registry (`ghcr.io/rossigee/...`), Features, Getting Started (prereqs,
install, ProviderConfig), Usage, Resource Types, Development, Contributing,
License. State exact Crossplane floor (`>= v2.5`, see
`docs/standards/platform.md`) and document both v1/v2 API variants where both
exist.

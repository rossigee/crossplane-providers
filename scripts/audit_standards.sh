#!/bin/bash
# Standards compliance audit for Crossplane provider submodules.
#
# Computes ground truth for each provider-* submodule directly from repo
# state (go.mod, Makefile, .gitmodules, .github/workflows, package/,
# Dockerfile, README.md) rather than relying on hand-maintained docs.
#
# Canonical standard (derived from docs/templates/ci-template.yml and the
# rossigee/build submodule, which are more authoritative than prose docs):
#   - Go version:            1.27.1
#   - golangci-lint version: 2.13.2
#   - build submodule:       github.com/rossigee/build @ rossigee-lint-fixes @ e5bf20a
#   - runtime:               crossplane-runtime/v2 v2.5.0 (rossigee fork)
#   - crossplane CLI:        v2.5.0 from cli.crossplane.io
#   - crossplane core floor: >= v2.5 (see docs/standards/platform.md)
#   - pre-commit:            v6.0.0, hadolint v2.12.0
#   - workflows:             ci.yml, release.yml, security.yml, auto-merge.yml,
#                             .github/dependabot.yml
#   - package/crossplane.yaml (not package.yaml)
#   - Dockerfile: ENTRYPOINT (not CMD)
#
# Usage: ./scripts/audit_standards.sh [--format text|csv|markdown] [provider-dir...]

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

STD_GO_VERSION="1.27.1"
STD_LINT_VERSION="2.13.2"
STD_BUILD_BRANCH="rossigee-lint-fixes"
STD_BUILD_URL="https://github.com/rossigee/build"
STD_RUNTIME_VERSION="v2.5.0"
STD_RUNTIME_FORK="github.com/rossigee/crossplane-runtime/v2"
STD_CLI_VERSION="v2.5.0"

FORMAT="text"
PROVIDERS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [--format text|csv|markdown] [provider-dir...]"
            exit 0
            ;;
        *)
            PROVIDERS="$PROVIDERS $1"
            shift
            ;;
    esac
done

if [ -z "$PROVIDERS" ]; then
    PROVIDERS=$(ls -d "$REPO_ROOT"/provider-*/ 2>/dev/null | xargs -n1 basename)
fi

# field(file, pattern) -> first regex-captured value or "-"
field() {
    local file="$1" pattern="$2"
    [ -f "$file" ] || { echo "-"; return; }
    grep -oE "$pattern" "$file" 2>/dev/null | head -1
}

audit_provider() {
    local name="$1"
    local dir="$REPO_ROOT/$name"

    local go_version makefile_go makefile_lint build_url build_branch build_commit
    local wf_ci wf_release wf_security wf_automerge wf_dependabot ci_go_version
    local pkg_ok dockerfile entrypoint_ok oci_labels readme_sections
    local runtime_version runtime_fork cli_version

    go_version=$(field "$dir/go.mod" '^go [0-9.]+' | awk '{print $2}')
    [ -z "$go_version" ] && go_version="-"

    makefile_go=$(field "$dir/Makefile" 'GO_REQUIRED_VERSION[[:space:]]*\??=[[:space:]]*[0-9.]+' | grep -oE '[0-9.]+$')
    [ -z "$makefile_go" ] && makefile_go="-"

    makefile_lint=$(field "$dir/Makefile" 'GOLANGCILINT_VERSION[[:space:]]*\??=[[:space:]]*[0-9.]+' | grep -oE '[0-9.]+$')
    [ -z "$makefile_lint" ] && makefile_lint="-"

    build_url=$(field "$dir/.gitmodules" 'url = .*' | tr -d '\r')
    build_url="${build_url#url = }"
    [ -z "$build_url" ] && build_url="-"

    if [ -d "$dir/build/.git" ] || [ -f "$dir/build/.git" ]; then
        build_commit=$(git -C "$dir/build" rev-parse --short HEAD 2>/dev/null || echo "-")
        build_branch=$(git -C "$dir/build" branch -r --contains HEAD 2>/dev/null \
            | sed 's#^[* ]*origin/##' | grep -v '^HEAD' | head -1)
        [ -z "$build_branch" ] && build_branch="detached"
    else
        build_commit="not-init"
        build_branch="not-init"
    fi

    for wf in ci release security auto-merge; do
        varname="wf_${wf//-/}"
        if [ -f "$dir/.github/workflows/${wf}.yml" ]; then
            printf -v "$varname" "yes"
        else
            printf -v "$varname" "no"
        fi
    done

    if [ -f "$dir/.github/dependabot.yml" ]; then
        wf_dependabot="yes"
    else
        wf_dependabot="no"
    fi

    ci_go_version=$(field "$dir/.github/workflows/ci.yml" "GO_VERSION:[[:space:]]*'[0-9.]+'" | grep -oE '[0-9.]+')
    [ -z "$ci_go_version" ] && ci_go_version="-"

    runtime_version=$(grep -E '^\s*github.com/crossplane/crossplane-runtime/v2\s+v[0-9.]+' "$dir/go.mod" 2>/dev/null | awk '{print $2}' | head -1)
    [ -z "$runtime_version" ] && runtime_version="-"

    runtime_fork=$(grep -E 'replace\s+github.com/crossplane/crossplane-runtime/v2\s+=>' "$dir/go.mod" 2>/dev/null | grep -oE 'github.com/[a-zA-Z0-9_.-]+/crossplane-runtime/v2' | tail -1)
    [ -z "$runtime_fork" ] && runtime_fork="-"

    cli_version=$(grep -oE 'CROSSPLANE_CLI_VERSION\s*\?*=\s*v[0-9.]+' "$dir/build/makelib/k8s_tools.mk" 2>/dev/null | grep -oE 'v[0-9.]+$' | head -1)
    [ -z "$cli_version" ] && cli_version="-"

    if [ -f "$dir/package/crossplane.yaml" ]; then
        pkg_ok="yes"
    elif [ -f "$dir/package/package.yaml" ]; then
        pkg_ok="WRONG-NAME"
    else
        pkg_ok="missing"
    fi

    dockerfile=$(find "$dir/cluster/images" -iname "Dockerfile" 2>/dev/null | head -1)
    if [ -z "$dockerfile" ]; then
        entrypoint_ok="no-dockerfile"
    elif grep -q '^ENTRYPOINT' "$dockerfile" && ! grep -q '^CMD' "$dockerfile"; then
        entrypoint_ok="yes"
    elif grep -q '^CMD' "$dockerfile"; then
        entrypoint_ok="uses-CMD"
    else
        entrypoint_ok="no-entrypoint"
    fi

    if [ -n "$dockerfile" ]; then
        oci_labels=$(grep -c 'org.opencontainers.image\.' "$dockerfile" 2>/dev/null)
        [ -z "$oci_labels" ] && oci_labels=0
    else
        oci_labels=0
    fi

    if [ -f "$dir/README.md" ]; then
        readme_sections=0
        for section in "Container Registry" "Getting Started" "Resource Types" "Development" "Contributing" "License"; do
            grep -q "^#.*$section" "$dir/README.md" && readme_sections=$((readme_sections + 1))
        done
    else
        readme_sections="no-readme"
    fi

    echo "$name|$go_version|$makefile_go|$makefile_lint|$build_url|$build_branch|$build_commit|$wf_ci|$wf_release|$wf_security|$wf_automerge|$wf_dependabot|$ci_go_version|$pkg_ok|$entrypoint_ok|$oci_labels|$readme_sections|$runtime_version|$runtime_fork|$cli_version"
}

HEADER="provider|go.mod|makefile_go|makefile_lint|build_url|build_branch|build_commit|ci.yml|release.yml|security.yml|auto-merge.yml|dependabot.yml|ci_go_version|package_file|dockerfile_entrypoint|oci_labels(/7)|readme_sections(/6)|runtime_version|runtime_fork|cli_version"

ROWS=()
for provider in $PROVIDERS; do
    provider="${provider%/}"
    [ -d "$REPO_ROOT/$provider" ] || continue
    ROWS+=("$(audit_provider "$provider")")
done

case "$FORMAT" in
    csv)
        echo "$HEADER" | tr '|' ','
        for row in "${ROWS[@]}"; do echo "$row" | tr '|' ','; done
        ;;
    markdown)
        IFS='|' read -ra COLS <<< "$HEADER"
        printf '|'; for c in "${COLS[@]}"; do printf ' %s |' "$c"; done; echo
        printf '|'; for c in "${COLS[@]}"; do printf ' --- |'; done; echo
        for row in "${ROWS[@]}"; do
            IFS='|' read -ra VALS <<< "$row"
            printf '|'; for v in "${VALS[@]}"; do printf ' %s |' "$v"; done; echo
        done
        ;;
    text|*)
        echo "Standards Audit — canonical: Go $STD_GO_VERSION, golangci-lint $STD_LINT_VERSION, build@$STD_BUILD_BRANCH, runtime $STD_RUNTIME_VERSION ($STD_RUNTIME_FORK), CLI $STD_CLI_VERSION, core >= v2.5 (docs/standards/platform.md)"
        echo "======================================================================"
        for row in "${ROWS[@]}"; do
            IFS='|' read -r name go_v mk_go mk_lint b_url b_branch b_commit ci rel sec am dep ci_go pkg ep oci readme rt_v rt_fork cli_v <<< "$row"
            echo "-- $name --"
            [ "$go_v" != "$STD_GO_VERSION" ] && echo "  [DRIFT] go.mod version=$go_v (want $STD_GO_VERSION)"
            [ "$mk_go" != "${STD_GO_VERSION%.*}" ] && [ "$mk_go" != "$STD_GO_VERSION" ] && echo "  [DRIFT] Makefile GO_REQUIRED_VERSION=$mk_go"
            [ "$mk_lint" != "$STD_LINT_VERSION" ] && echo "  [DRIFT] Makefile GOLANGCILINT_VERSION=$mk_lint (want $STD_LINT_VERSION)"
            [ "$b_url" != "$STD_BUILD_URL" ] && echo "  [DRIFT] build submodule url=$b_url"
            [ "$b_branch" != "$STD_BUILD_BRANCH" ] && echo "  [DRIFT] build submodule branch=$b_branch (want $STD_BUILD_BRANCH)"
            [ "$ci" != "yes" ] && echo "  [MISSING] ci.yml"
            [ "$rel" != "yes" ] && echo "  [MISSING] release.yml"
            [ "$sec" != "yes" ] && echo "  [MISSING] security.yml"
            [ "$am" != "yes" ] && echo "  [MISSING] auto-merge.yml"
            [ "$dep" != "yes" ] && echo "  [MISSING] .github/dependabot.yml"
            [ "$pkg" != "yes" ] && echo "  [FAIL] package file: $pkg"
            [ "$ep" != "yes" ] && echo "  [FAIL] dockerfile entrypoint: $ep"
            [ "$oci" != "7" ] && echo "  [PARTIAL] oci labels: $oci/7"
            [ "$readme" != "6" ] && echo "  [PARTIAL] readme sections: $readme/6"
            [ "$rt_v" != "$STD_RUNTIME_VERSION" ] && echo "  [DRIFT] runtime version=$rt_v (want $STD_RUNTIME_VERSION)"
            [ "$rt_fork" != "$STD_RUNTIME_FORK" ] && echo "  [DRIFT] runtime fork=$rt_fork (want $STD_RUNTIME_FORK)"
            [ "$cli_v" != "$STD_CLI_VERSION" ] && echo "  [DRIFT] crossplane CLI=$cli_v (want $STD_CLI_VERSION)"
        done
        ;;
esac

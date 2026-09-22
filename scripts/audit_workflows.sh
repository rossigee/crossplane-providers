#!/usr/bin/env bash
#
# audit_workflows.sh
#
# Audits workflow drift between providers and the canonical templates
# in docs/templates/.
#
# Usage: ./scripts/audit_workflows.sh [output.md]
#
# Outputs a markdown report of differences in:
#   - .github/workflows/{release,ci,auto-merge,security}.yml
#   - Presence of publishing overrides in Makefile
#   - Custom steps (e.g. libvirt-dev, system deps)
#   - Header version drift
#
# Run from the root of the crossplane-providers meta-repo.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$ROOT/docs/templates"
OUTPUT="${1:-/dev/stdout}"

# Map workflow filename to template name
declare -A TEMPLATE_MAP=(
  [release.yml]="release-template.yml"
  [ci.yml]="ci-template.yml"
  [auto-merge.yml]="auto-merge.yml"
  [security.yml]="security-template.yml"
)

echo "# Crossplane Providers - Workflow Drift Audit" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$OUTPUT"
echo "Template version reference: 2026-09-08" >> "$OUTPUT"
echo "" >> "$OUTPUT"

echo "## Summary" >> "$OUTPUT"
echo "" >> "$OUTPUT"

total_providers=0
release_drift=0
ci_drift=0
has_xpkg_override=0
has_img_neutralize=0
custom_steps=""

for provider_dir in "$ROOT"/provider-*; do
  [[ -d "$provider_dir" ]] || continue
  name=$(basename "$provider_dir")
  # Skip meta or non-provider dirs if any
  [[ "$name" == "provider-openstack" ]] && continue  # example exclusion

  total_providers=$((total_providers + 1))

  echo "## $name" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  # --- Workflows ---
  for wf in release ci auto-merge security; do
    actual="$provider_dir/.github/workflows/${wf}.yml"
    tmpl_name="${TEMPLATE_MAP[${wf}.yml]}"
    template="$TEMPLATE_DIR/$tmpl_name"

    if [[ ! -f "$actual" ]]; then
      echo "- **${wf}.yml**: MISSING" >> "$OUTPUT"
      continue
    fi

    if [[ ! -f "$template" ]]; then
      echo "- **${wf}.yml**: no matching template ($tmpl_name)" >> "$OUTPUT"
      continue
    fi

    diff_out=$(diff -u "$template" "$actual" 2>/dev/null || true)
    diff_lines=$(echo "$diff_out" | wc -l | awk '{print $1}')

    # Extract header version if present
    header=$(grep -E '^# Version:' "$actual" | head -1 || echo "(no version header)")

    status="matches template"
    if [[ "$diff_lines" -gt 5 ]]; then
      status="${diff_lines} lines differ"
      if [[ "$wf" == "release" ]]; then release_drift=$((release_drift + 1)); fi
      if [[ "$wf" == "ci" ]]; then ci_drift=$((ci_drift + 1)); fi
    fi

    echo "- **${wf}.yml**: $status | $header" >> "$OUTPUT"

    # Detect obvious custom steps
    if grep -qE 'Install .*Dependencies|libvirt-dev|apt-get|dpkg --add-architecture' "$actual" 2>/dev/null; then
      echo "  - contains provider-specific system dependency step" >> "$OUTPUT"
      custom_steps="${custom_steps} ${name}/${wf}"
    fi
  done

  # --- Makefile publishing overrides (related to release reliability) ---
  makefile="$provider_dir/Makefile"
  if [[ -f "$makefile" ]]; then
    if grep -q 'xpkg.release.publish.ghcr.io/rossigee.provider-' "$makefile" 2>/dev/null; then
      echo "- Makefile: has \`xpkg.release.publish.ghcr.io/rossigee.provider-*\` override" >> "$OUTPUT"
      has_xpkg_override=$((has_xpkg_override + 1))
    else
      echo "- Makefile: uses stock build/makelib publishing (no override)" >> "$OUTPUT"
    fi

    if grep -q 'img.release.publish.ghcr.io/rossigee.provider-' "$makefile" 2>/dev/null; then
      echo "- Makefile: has \`img.release.publish\` neutralization" >> "$OUTPUT"
      has_img_neutralize=$((has_img_neutralize + 1))
    fi
  fi

  echo "" >> "$OUTPUT"
done

echo "## Aggregate Stats" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "- Total providers scanned: $total_providers" >> "$OUTPUT"
echo "- Release workflows with significant drift: $release_drift" >> "$OUTPUT"
echo "- CI workflows with significant drift: $ci_drift" >> "$OUTPUT"
echo "- Providers with xpkg.release.publish override: $has_xpkg_override" >> "$OUTPUT"
echo "- Providers with img.release neutralization: $has_img_neutralize" >> "$OUTPUT"
echo "" >> "$OUTPUT"

if [[ -n "$custom_steps" ]]; then
  echo "## Detected Custom Steps" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo "$custom_steps" | tr ' ' '\n' | sort -u | sed 's/^/- /' >> "$OUTPUT"
  echo "" >> "$OUTPUT"
fi

echo "## Recommendations" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "See AGENTS.md and docs/standards/ for standardization policy." >> "$OUTPUT"
echo "Run this script regularly or add to CI." >> "$OUTPUT"

echo "Audit complete. Output written to $OUTPUT" >&2

#!/bin/bash
set -euo pipefail

# update-docs.sh - Update provider versions in docs homepage
# Fetches latest release info from GitHub and updates docs/docs/index.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
INDEX_FILE="$REPO_ROOT/docs/docs/index.md"
BACKUP_FILE="$INDEX_FILE.bak"

PROVIDERS=(
  "provider-backblaze"
  "provider-btcpay"
  "provider-cloudflare"
  "provider-discord"
  "provider-docker"
  "provider-gitea"
  "provider-harbor"
  "provider-hostinger"
  "provider-http"
  "provider-keycloak"
  "provider-libvirt"
  "provider-matrix"
  "provider-minio"
  "provider-namecheap"
  "provider-openstack"
  "provider-plausible"
  "provider-rabbitmq"
  "provider-signoz"
  "provider-vault"
)

echo "Fetching latest releases from GitHub..."

declare -A versions
declare -A dates

for provider in "${PROVIDERS[@]}"; do
  data=$(curl -s "https://api.github.com/repos/rossigee/$provider/releases/latest" 2>/dev/null)
  if [ -n "$data" ] && [ "$(echo "$data" | jq -r '.tag_name // empty')" != "null" ]; then
    versions[$provider]=$(echo "$data" | jq -r '.tag_name')
    dates[$provider]=$(echo "$data" | jq -r '.published_at[:10]')
    echo "$provider: ${versions[$provider]} (${dates[$provider]})"
  else
    versions[$provider]="—"
    dates[$provider]="—"
    echo "$provider: no release"
  fi
done

echo ""
echo "Backing up $INDEX_FILE to $BACKUP_FILE"
cp "$INDEX_FILE" "$BACKUP_FILE"

echo "Updating $INDEX_FILE..."

for provider in "${PROVIDERS[@]}"; do
  short="${provider#provider-}"
  sed -i "s/| $short | v[0-9.]* | [0-9-]* |/| $short | ${versions[$provider]} | ${dates[$provider]} |/g" "$INDEX_FILE"
done

echo "Done. Review changes with: diff $BACKUP_FILE $INDEX_FILE"
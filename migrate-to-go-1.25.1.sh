#!/bin/bash
# Bulk migration script to Go 1.25.1 for all providers
set -e

echo "🚀 Migrating all providers to Go 1.25.1..."

# Update go.mod files
for provider in provider-*; do
  if [ -f "$provider/go.mod" ]; then
    echo "📝 Updating $provider/go.mod"
    sed -i 's/^go 1\.[0-9][0-9]*.*$/go 1.25.1/' "$provider/go.mod"
    
    # Fix module paths for the stragglers
    if grep -q "crossplane-contrib" "$provider/go.mod"; then
      echo "🔧 Fixing module path for $provider"
      sed -i 's|crossplane-contrib|rossigee|g' "$provider/go.mod"
    fi
  fi
done

# Update CI workflows
for provider in provider-*; do
  if [ -f "$provider/.github/workflows/ci.yml" ]; then
    echo "⚙️  Updating $provider CI workflow"
    sed -i "s/GO_VERSION: '[0-9]\+\.[0-9]\+\.*[0-9]*'/GO_VERSION: '1.25.1'/" "$provider/.github/workflows/ci.yml"
  fi
done

# Standardize golangci-lint version
for provider in provider-*; do
  if [ -f "$provider/Makefile" ]; then
    echo "🔨 Standardizing golangci-lint for $provider"
    sed -i 's/GOLANGCILINT_VERSION ?= 2.4.0/GOLANGCILINT_VERSION ?= 2.3.1/' "$provider/Makefile"
  fi
done

echo "✅ Migration complete!"
echo ""
echo "🔍 Verification:"
echo "Go versions:"
grep -h "^go " provider-*/go.mod | sort | uniq -c

echo ""
echo "CI Go versions:"
grep -h "GO_VERSION:" provider-*/.github/workflows/ci.yml 2>/dev/null | sort | uniq -c

echo ""
echo "golangci-lint versions:"
grep -h "GOLANGCILINT_VERSION" provider-*/Makefile | sort | uniq -c

echo ""
echo "🧪 Test one provider:"
echo "cd provider-minio && make build"
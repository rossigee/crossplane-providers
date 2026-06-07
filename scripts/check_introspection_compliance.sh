#!/bin/bash
# Compliance check script for Crossplane provider introspection and drift detection patterns
# 
# This script verifies that all providers implement the required Observe pattern for:
# 1. Importing existing resources (read-only introspection)
# 2. Drift detection (comparing desired state vs actual state)
#
# Usage: ./scripts/check_introspection_compliance.sh [--verbose] [provider-dir...]

set -e

VERBOSE=${VERBOSE:-0}

# Get script directory for default provider list
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Default to all providers in repo if no arguments provided
if [ $# -eq 0 ]; then
    PROVIDERS=$(ls -d "$REPO_ROOT"/provider-* 2>/dev/null || true)
    if [ -z "$PROVIDERS" ]; then
        echo "Error: No providers found in $REPO_ROOT"
        exit 1
    fi
else
    PROVIDERS=$@
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
WARNINGS=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED++))
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

log_info() {
    if [ "$VERBOSE" = "1" ]; then
        echo -e "[INFO] $1"
    fi
}

check_controller() {
    local controller_file=$1
    local controller_name=$(basename $(dirname $controller_file))
    local provider_name=$(basename $(dirname $(dirname $(dirname $controller_file))))
    
    # Skip root controller.go files (setup aggregators, not managed resource controllers)
    if [[ "$controller_name" == "controller" ]] && [[ ! "$controller_file" == *"/internal/controller/"*"/"* ]]; then
        return 0
    fi
    
    log_info "Checking $provider_name/$controller_name..."
    
    # Check 1: Observe method exists (match any External type name)
    if grep -qi "func.*External.*Observe" "$controller_file"; then
        log_info "  - Observe method found"
    else
        log_fail "$provider_name/$controller_name: Missing Observe method"
        return 1
    fi
    
    # Check 2: Returns ExternalObservation
    if grep -q "ExternalObservation" "$controller_file"; then
        log_info "  - ExternalObservation return type found"
    else
        log_fail "$provider_name/$controller_name: Missing ExternalObservation return"
        return 1
    fi
    
    # Check 3: Sets ResourceExists
    if grep -q "ResourceExists:" "$controller_file"; then
        log_info "  - ResourceExists field set"
    else
        log_fail "$provider_name/$controller_name: Missing ResourceExists in observation"
        return 1
    fi
    
    # Check 4: Drift detection (ResourceUpToDate)
    if grep -q "ResourceUpToDate:" "$controller_file"; then
        log_info "  - ResourceUpToDate (drift detection) found"
    else
        log_warn "$provider_name/$controller_name: Missing drift detection (ResourceUpToDate)"
        return 1
    fi
    
    # Check 5: upToDate helper function (optional but recommended)
    if grep -q "func.*[a-zA-Z]*UpToDate" "$controller_file"; then
        log_info "  - upToDate helper function found"
    fi
    
    log_pass "$provider_name/$controller_name: Compliant"
    return 0
}

check_provider() {
    local provider_dir=$1
    
    if [ ! -d "$provider_dir/internal/controller" ]; then
        log_info "Skipping $provider_dir: no controller directory"
        return 0
    fi
    
    echo "=============================================="
    echo "Checking provider: $(basename $provider_dir)"
    echo "=============================================="
    
    # Find all Go files in controller directories (excluding test files, helpers, and generated files)
    local controllers=$(find "$provider_dir/internal/controller" -name "*.go" \
        ! -name "*_test.go" \
        ! -name "zz_*.go" \
        ! -name "*_suite_test.go" \
        ! -name "helpers.go" \
        ! -name "config.go" \
        ! -name "setup.go" \
        ! -name "doc.go" \
        ! -name "deduplication.go" \
        ! -name "mocks.go" \
        ! -name "observe.go" \
        ! -path "*/testing/*" \
        ! -path "*/requestgen/*" \
        ! -path "*/requestprocessing/*" \
        ! -path "*/responseconverter/*" \
        ! -path "*/statushandler/*" \
        ! -path "*/requestmapping/*" \
        ! -path "*/observe/*" \
        ! -path "*/pcusage/*" \
        -type f)
    
    if [ -z "$controllers" ]; then
        log_warn "$(basename $provider_dir): No controller implementations found"
        return 0
    fi
    
    for controller in $controllers; do
        check_controller "$controller" || true
    done
    
    echo ""
}

echo "Crossplane Provider Introspection & Drift Detection Compliance Check"
echo "======================================================================"
echo ""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose)
            VERBOSE=1
            shift
            ;;
        --help)
            echo "Usage: $0 [--verbose] [provider-dir...]"
            echo ""
            echo "Options:"
            echo "  --verbose    Enable verbose output"
            echo "  provider-dir Provider directories to check (default: all)"
            exit 0
            ;;
        *)
            PROVIDERS="$@"
            break
            ;;
    esac
    shift
done

# Check each provider
for provider in $PROVIDERS; do
    check_provider "$provider"
done

echo "======================================================================"
echo "Results Summary"
echo "======================================================================"
echo -e "Passed:  ${GREEN}$PASSED${NC}"
echo -e "Failed:  ${RED}$FAILED${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Compliance check FAILED${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Compliance check passed with warnings${NC}"
    exit 0
else
    echo -e "${GREEN}Compliance check PASSED${NC}"
    exit 0
fi
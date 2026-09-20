#!/usr/bin/env bash
set -euo pipefail
REPO="/home/rossg/src/crossplane-providers"

# ---- OTLP per provider ----
for d in "$REPO"/provider-*; do
  [[ -d $d ]] || continue
  name=$(basename "$d")
  trc="$d/internal/tracing/tracing.go"
  if grep -q "otlptrace\.New\|otlptracegrpc" "$trc" 2>/dev/null; then
    otp=2
  else
    otp=0
  fi
  echo "$name OTLP=$otp"
done

# ---- Retry-After per provider ----
for d in "$REPO"/provider-*; do
  [[ -d $d ]] || continue
  name=$(basename "$d")
  if grep -rn 'resp\.Header\.Get("Retry-After")' "$d"/internal/clients/*.go 2>/dev/null; then
    rat=2
  else
    rat=0
  fi
  echo "$name Retry=$rat"
done

# ---- EventRecorder per provider ----
for d in "$REPO"/provider-*; do
  [[ -d $d ]] || continue
  name=$(basename "$d")
  if grep -rn "event\.NewAPIRecorder" "$d"/internal/controller/**/*.go 2>/dev/null; then
    ev=2
  else
    ev=0
  fi
  echo "$name Event=$ev"
done
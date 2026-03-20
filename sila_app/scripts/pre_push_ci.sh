#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
APP_DIR="$REPO_ROOT/sila_app"

if [ ! -d "$APP_DIR" ]; then
  echo "[pre-push] Could not find Flutter app directory: $APP_DIR"
  exit 1
fi

cd "$APP_DIR"

echo "[pre-push] Running local CI checks..."
flutter pub get

UPSTREAM_REF="$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null || true)"
if [ -n "$UPSTREAM_REF" ]; then
  BASE_SHA="$(git merge-base HEAD "$UPSTREAM_REF")"
  DIFF_RANGE="$BASE_SHA..HEAD"
else
  DIFF_RANGE="HEAD"
fi

mapfile -t CHANGED_DART_FILES < <(git diff --name-only --diff-filter=ACMRT $DIFF_RANGE -- '*.dart')

if [ ${#CHANGED_DART_FILES[@]} -gt 0 ]; then
  echo "[pre-push] Checking formatting for changed Dart files..."
  dart format --output=none --set-exit-if-changed "${CHANGED_DART_FILES[@]}"
else
  echo "[pre-push] No changed Dart files to format-check"
fi

if [ ${#CHANGED_DART_FILES[@]} -gt 0 ]; then
  echo "[pre-push] Running analyzer for changed Dart files..."
  flutter analyze --no-fatal-infos --no-fatal-warnings "${CHANGED_DART_FILES[@]}"
else
  echo "[pre-push] No changed Dart files to analyze"
fi

if [ -n "$(git ls-files -- 'test/**')" ]; then
  flutter test
else
  echo "[pre-push] No tests found, skipping flutter test"
fi

echo "[pre-push] All checks passed. Push allowed."

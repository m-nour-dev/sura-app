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

if [ -d test ]; then
  dart format --output=none --set-exit-if-changed lib test
else
  dart format --output=none --set-exit-if-changed lib
fi

flutter analyze

if [ -n "$(git ls-files -- 'test/**')" ]; then
  flutter test
else
  echo "[pre-push] No tests found, skipping flutter test"
fi

echo "[pre-push] All checks passed. Push allowed."

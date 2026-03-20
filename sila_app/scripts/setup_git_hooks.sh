#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

mkdir -p "$HOOKS_DIR"

TARGET_HOOK="$HOOKS_DIR/pre-push"
if [ -f "$TARGET_HOOK" ]; then
  if grep -q 'sila_app/scripts/pre_push_ci.sh' "$TARGET_HOOK"; then
    echo "[hooks] pre-push hook already installed; nothing to do"
    exit 0
  fi

  BACKUP_HOOK="$TARGET_HOOK.backup.$(date +%Y%m%d%H%M%S)"
  cp "$TARGET_HOOK" "$BACKUP_HOOK"
  echo "[hooks] Existing pre-push hook detected; backed up to $BACKUP_HOOK"
fi

cat > "$TARGET_HOOK" <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
bash "$REPO_ROOT/sila_app/scripts/pre_push_ci.sh"
HOOK

chmod +x "$TARGET_HOOK"

echo "[hooks] Installed pre-push hook at $TARGET_HOOK"

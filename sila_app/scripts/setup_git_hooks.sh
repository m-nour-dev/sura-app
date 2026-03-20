#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

mkdir -p "$HOOKS_DIR"

cat > "$HOOKS_DIR/pre-push" <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
bash "$REPO_ROOT/sila_app/scripts/pre_push_ci.sh"
HOOK

chmod +x "$HOOKS_DIR/pre-push"

echo "[hooks] Installed pre-push hook at $HOOKS_DIR/pre-push"

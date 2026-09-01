#!/usr/bin/env bash
# Promote the canonical Neovim checkout into a source-free runtime config.
set -euo pipefail
umask 077

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SOURCE_DIR
TARGET_DIR="${NVIM_CONFIG_TARGET:-${HOME}/.config/nvim}"
readonly TARGET_DIR

[[ "$TARGET_DIR" != "$SOURCE_DIR" ]] || {
  printf '%s\n' 'refusing to deploy over the canonical checkout' >&2
  exit 2
}
command -v rsync >/dev/null || { printf '%s\n' 'rsync is required' >&2; exit 1; }
command -v nvim >/dev/null || { printf '%s\n' 'nvim is required' >&2; exit 1; }
command -v timeout >/dev/null || { printf '%s\n' 'timeout is required' >&2; exit 1; }
[[ -f "$SOURCE_DIR/init.lua" && -d "$SOURCE_DIR/lua" ]] || {
  printf 'canonical Neovim config is incomplete: %s\n' "$SOURCE_DIR" >&2
  exit 1
}

git -C "$SOURCE_DIR" diff --quiet
git -C "$SOURCE_DIR" diff --cached --quiet
[[ -z "$(git -C "$SOURCE_DIR" status --porcelain --untracked-files=normal)" ]] || {
  printf '%s\n' 'refusing to deploy a dirty Neovim checkout' >&2
  exit 1
}
head_oid="$(git -C "$SOURCE_DIR" rev-parse HEAD)"
upstream_oid="$(git -C "$SOURCE_DIR" rev-parse '@{upstream}')"
[[ "$head_oid" == "$upstream_oid" ]] || {
  printf '%s\n' 'refusing to deploy Neovim before HEAD is pushed' >&2
  exit 1
}

mkdir -p -- "$(dirname -- "$TARGET_DIR")"
staging_dir="$(mktemp -d "${TARGET_DIR}.release.XXXXXX")"
rollback_dir="$(mktemp -d "${TARGET_DIR}.rollback.XXXXXX")"
cleanup() {
  rm -rf -- "${staging_dir:-}" "${rollback_dir:-}"
}
trap cleanup EXIT

rsync -a \
  --exclude='/.git/' \
  --exclude='/.gitignore' \
  --exclude='/deploy.sh' \
  --exclude='/README.md' \
  --exclude='/readme.md' \
  -- "$SOURCE_DIR/" "$staging_dir/"

while IFS= read -r -d '' file; do
  NVIM_VALIDATE_FILE="$file" timeout 10 nvim --headless --clean -u NONE \
    '+lua assert(loadfile(vim.env.NVIM_VALIDATE_FILE))' '+qa'
done < <(find "$staging_dir" -type f -name '*.lua' -print0)

had_previous=0
if [[ -e "$TARGET_DIR" || -L "$TARGET_DIR" ]]; then
  [[ -d "$TARGET_DIR" && ! -L "$TARGET_DIR" ]] || {
    printf 'refusing to replace non-directory Neovim runtime: %s\n' "$TARGET_DIR" >&2
    exit 1
  }
  mv -- "$TARGET_DIR" "$rollback_dir/config"
  had_previous=1
fi
if ! mv -- "$staging_dir" "$TARGET_DIR"; then
  if ((had_previous)); then
    mv -- "$rollback_dir/config" "$TARGET_DIR"
  fi
  exit 1
fi
staging_dir=""

if ! timeout 30 nvim --headless '+qa'; then
  rm -rf -- "$TARGET_DIR"
  if ((had_previous)); then
    mv -- "$rollback_dir/config" "$TARGET_DIR"
  fi
  printf '%s\n' 'Neovim runtime smoke failed; deployment rolled back' >&2
  exit 1
fi

rm -rf -- "$rollback_dir/config"
printf 'deployed Neovim config from %s to %s\n' "$SOURCE_DIR" "$TARGET_DIR"

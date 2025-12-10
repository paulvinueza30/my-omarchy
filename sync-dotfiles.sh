#!/bin/bash

set -e

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin

get_ts() {
  date +'%Y-%m-%d %H:%M:%S'
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
  local level="$1"
  local message="$2"
  timestamp=$(get_ts)

  local log_line="${timestamp} [${level}] ${message}"
  echo "$log_line" >>"$LOG_FILE"

  case "$level" in
  "INFO") echo -e "${timestamp} ${BLUE}[INFO]${NC} $message" ;;
  "SUCCESS") echo -e "${timestamp} ${GREEN}[OK]${NC}   $message" ;;
  "WARN") echo -e "${timestamp} ${YELLOW}[WARN]${NC} $message" ;;
  "ERROR") echo -e "${timestamp} ${RED}[ERR]${NC}  $message" ;;
  *) echo -e "${timestamp} [LOG]  $message" ;;
  esac
}

# Get user's home directory reliably
EFFECTIVE_USER=$(id -un)
USER_HOME=$(getent passwd "$EFFECTIVE_USER" 2>/dev/null | cut -d: -f6)

# Fallback to $HOME if getent fails, but prefer the looked-up value
if [ -z "$USER_HOME" ] || [ ! -d "$USER_HOME" ]; then
  USER_HOME="${HOME:-~$EFFECTIVE_USER}"
fi

LOG_DIR="${LOG_DIR:-$USER_HOME/.local/log/sync-dotfiles}"
LOG_FILE="$LOG_DIR/sync-dotfiles.log"

mkdir -p "$LOG_DIR"

DOTFILES_DIR="${DOTFILES_DIR:-$USER_HOME/dotfiles}"

log "INFO" "Starting dotfiles sync"
log "INFO" "Using DOTFILES_DIR: $DOTFILES_DIR"

if [ ! -d "$DOTFILES_DIR" ]; then
  log "ERROR" "DOTFILES_DIR ($DOTFILES_DIR) not found, exiting..."
  exit 1
fi

cd "$DOTFILES_DIR"

# prevent git from tracking changes to .localignore file itself
git update-index --skip-worktree .localignore

# fetch latest to update origin/main reference
git fetch origin main

# roll back any commmits that didn't get approved but keep it locally
git reset --soft origin/main

# sync up to main
if ! git pull --autostash origin main; then
  log "ERROR" "git pull failed, resolve conflicts, exiting..."
  exit 1
fi

GIT_STATUS=$(git status --porcelain)

if [ -z "$GIT_STATUS" ]; then
  log "INFO" "No changes detected, exiting..."
  exit 0
fi

git add .

# unstage anything in .localignore
log "INFO" "Checking .localignore..."
while IFS= read -r path; do
  [[ -z "$path" || "$path" =~ ^# ]] && continue

  # check for file or dir
  if git diff --name-only --cached | grep -qE "^$path(/|$)"; then
    log "INFO" "  - Ignoring local changes to: $path"
    git restore --staged "$path"
  fi
done <".localignore"

if git diff --cached --quiet; then
  log "INFO" "No changes to sync (all changes were in .localignore)."
  exit 0
fi

TIMESTAMP=$(get_ts)
COMMIT_MSG="Auto-sync: $TIMESTAMP"
log "INFO" "Committing changes..."
git commit -m "$COMMIT_MSG"

log "INFO" "Pushing to origin/auto-sync..."
if ! git push --force-with-lease origin HEAD:auto-sync 2>&1; then
  log "ERROR" "git push failed"
  exit 1
fi

log "INFO" "Creating pull request..."
if command -v gh >/dev/null 2>&1; then
  if gh pr create --base main --head "auto-sync" --title "Auto sync for $TIMESTAMP" --body "Please review these changes carefully" 2>&1; then
    log "SUCCESS" "Pull request created successfully"
  else
    log "WARN" "Failed to create PR (may already exist or authentication issue)"
  fi
else
  log "WARN" "GitHub CLI (gh) not found, skipping PR creation"
fi

log "SUCCESS" "Dotfiles sync complete"
exit 0

#!/bin/bash

set -e

if gh auth status &>/dev/null; then
  echo "You already logged into GitHub CLI"
  exit 0
fi

KEY_NAME="gh_cli_id"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

ssh-keygen -t ed25519 -C "generated-by-gh-setup-script" -f "$KEY_PATH" -N ""
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

echo "Follow the instructions to login"
gh auth login --git-protocol ssh --web

echo "Finished setting up GitHub CLI"

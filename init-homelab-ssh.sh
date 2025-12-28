#!/bin/bash

KEY_PATH="$HOME/.ssh/id_homelab"
if [ ! -f "$KEY_PATH" ]; then
  echo "Generating new homelab key..."
  ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -q
fi

nodes=(
  root@10.0.0.72
  head@10.0.0.110
  worker-1@10.0.0.234
  worker-2@10.0.0.224
)

for node in "${nodes[@]}"; do
  ssh-copy-id -i ~/.ssh/id_homelab "$node"
  ENTRY=$(echo "$node" | cut -d "@" -f 1)
  echo "alias ${ENTRY}='ssh -i ~/.ssh/id_homelab ${node}'" >>~/dotfiles/zsh/.config/zsh/aliases.zsh
done

zsh

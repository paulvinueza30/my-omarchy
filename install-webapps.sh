#!/usr/bin/env bash
set -euo pipefail

if ! command -v omarchy-webapp-install >/dev/null 2>&1; then
  echo "omarchy-webapp-install not found"
  exit 1
fi

webapps=(
  "X|https://x.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/x-light.png"
  "LinkedIn|https://www.linkedin.com/feed/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/linkedin.png"
  "YouTube|https://youtube.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png"
  "GitHub|https://github.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png"
  "Twitch|https://twitch.tv/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/twitch.png"
  "Excalidraw|https://excalidraw.com|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/excalidraw.png"
  "Google Messages|https://messages.google.com/web/conversations|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-messages.png"
  "X Post|https://x.com/compose/post|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/x-light.png"
  "Reddit|https://www.reddit.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/reddit.png"
  "Gmail|https://mail.google.com/|https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/gmail.png"
  "NeetCode|https://neetcode.io/|https://avatars.githubusercontent.com/u/78177695?s=200&v=4"
)

for app in "${webapps[@]}"; do
  IFS='|' read -r name url icon <<< "$app"
  omarchy-webapp-install "$name" "$url" "$icon"
done

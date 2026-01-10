#!/usr/bin/env bash

STATE="$XDG_RUNTIME_DIR/voxtype.recording"

if [[ -f "$STATE" ]]; then
  voxtype record stop
  rm -f "$STATE"
else
  voxtype record start
  touch "$STATE"
fi

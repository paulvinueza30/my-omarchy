#!/bin/bash

sudo -v || exit 1

if [ $EUID != 0 ]; then
  sudo "$0" "$@"
  exit $?
fi

./spinner.sh ./install-all.sh

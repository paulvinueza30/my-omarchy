#!/bin/bash

set -e

yay -S --noconfirm cronie

sudo systemctl enable --now cronie.service

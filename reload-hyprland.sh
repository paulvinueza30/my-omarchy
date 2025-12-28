#!/bin/bash

hyprctl reload

pkill -9 waybar && waybar &

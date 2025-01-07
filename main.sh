#!/usr/bin/env bash
function _help() {
  echo "
Usage of setpaper.

  Flags:
    -h|--help : show this help
    -s|-w|--save|--write : save to ~/.config/wallpaper

  Example:
    setpaper ./wallpaper.jpg # sets wallpaper that doesn't save after reboot
    setpaper --save ./wallpaper.png # sets wallpaper and saves it
"
  exit 0
}

function error() {
  echo "$1
" >&2
  exit 1
}

# predefine functions
function load() {
  hyprctl hyprpaper unload "$1"
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper ",$1"
}

save=false
path=""

# parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    -s|-w|--save|--write)
      save="true" ;;
    -h|--help)
      _help ;;
    -*)
      error "Unknown option: $1";;
    *)
      path="$1" ;;
  esac
  shift
done
if [ "$path" == "" ]; then
  error "Path not provided"
elif [ ! -f "$path" ]; then
  error "File not found at $path".
fi

# operate
abs_path="$(realpath "$path")"
if "$save"; then
  ln -sf "$abs_path" ~/.config/wallpaper
  load ~/.config/wallpaper
else
  load "$abs_path"
fi

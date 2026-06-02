#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
conf="${LINUXTRACK_CONFIG:-$HOME/.config/linuxtrack/linuxtrack1.conf}"
profile="$repo_root/config/arma-reforger-profile.conf"
gamedata="$HOME/.config/linuxtrack/tir_firmware/gamedata.txt"

mkdir -p "$(dirname "$conf")"

if [[ -f "$conf" ]] && grep -n '^Title = Arma Reforger$' "$conf" >/dev/null 2>&1; then
  echo "Arma Reforger profile already exists in $conf"
else
  {
    printf '\n\n'
    cat "$profile"
    printf '\n'
  } >> "$conf"
  echo "Appended Arma Reforger profile to $conf"
fi

if [[ -f "$gamedata" ]] && ! grep -n '^8310 "Arma Reforger"$' "$gamedata" >/dev/null 2>&1; then
  tmp="$(mktemp)"
  awk 'NR == 1 { print; print "8310 \"Arma Reforger\""; next } { print }' "$gamedata" > "$tmp"
  mv "$tmp" "$gamedata"
  echo "Added Arma Reforger app ID 8310 to $gamedata"
elif [[ -f "$gamedata" ]]; then
  echo "Arma Reforger app ID already present in $gamedata"
else
  echo "Game data file not found yet: $gamedata" >&2
  echo "Extract game data first, then rerun this script." >&2
fi

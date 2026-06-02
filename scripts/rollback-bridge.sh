#!/usr/bin/env bash
set -euo pipefail

appid="${ARMA_REFORGER_APPID:-1874880}"
steam_root="${STEAM_ROOT:-$HOME/.local/share/Steam}"
game_dir="${ARMA_REFORGER_GAME_DIR:-$steam_root/steamapps/common/Arma Reforger}"
pfx="${ARMA_REFORGER_PFX:-$steam_root/steamapps/compatdata/$appid/pfx}"

rm -f "$game_dir/NPClient64.dll" "$game_dir/NPClient.dll"
rm -f "$pfx/drive_c/linuxtrack/NPClient64.dll" "$pfx/drive_c/linuxtrack/NPClient.dll"
rmdir "$pfx/drive_c/linuxtrack" 2>/dev/null || true

WINEPREFIX="$pfx" WINEDEBUG=-all wine reg delete \
  'HKCU\Software\NaturalPoint\NATURALPOINT\NPClient Location' \
  /f >/dev/null 2>&1 || true

echo "Rolled back staged Arma Reforger TrackIR bridge."

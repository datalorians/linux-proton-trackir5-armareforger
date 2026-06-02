#!/usr/bin/env bash
set -euo pipefail

appid="${ARMA_REFORGER_APPID:-1874880}"
steam_root="${STEAM_ROOT:-$HOME/.local/share/Steam}"
game_dir="${ARMA_REFORGER_GAME_DIR:-$steam_root/steamapps/common/Arma Reforger}"
pfx="${ARMA_REFORGER_PFX:-$steam_root/steamapps/compatdata/$appid/pfx}"
bridge="${LINUXTRACK_BRIDGE:-/tmp/trackir-linux-exuvo/src/wine_bridge/client/NPClient64.dll.so}"

if [[ ! -f "$bridge" ]]; then
  echo "Bridge not found: $bridge" >&2
  exit 1
fi

if [[ ! -d "$game_dir" ]]; then
  echo "Arma Reforger game directory not found: $game_dir" >&2
  exit 1
fi

if [[ ! -d "$pfx" ]]; then
  echo "Arma Reforger Proton prefix not found: $pfx" >&2
  echo "Launch Arma Reforger once through Steam, then retry." >&2
  exit 1
fi

mkdir -p "$pfx/drive_c/linuxtrack"
cp "$bridge" "$pfx/drive_c/linuxtrack/NPClient64.dll"
cp "$bridge" "$pfx/drive_c/linuxtrack/NPClient.dll"
cp "$bridge" "$game_dir/NPClient64.dll"
cp "$bridge" "$game_dir/NPClient.dll"

WINEPREFIX="$pfx" WINEDEBUG=-all wine reg add \
  'HKCU\Software\NaturalPoint\NATURALPOINT\NPClient Location' \
  /v Path /t REG_SZ /d 'C:\linuxtrack' /f

echo "Staged untested Arma Reforger TrackIR bridge."
echo "Next: launch once with Steam option: LINUXTRACK_DBG=w %command%"

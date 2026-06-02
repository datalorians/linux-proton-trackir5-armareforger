# Notes

## Why This Might Work

Arma Reforger's executable references `NPClient64.dll` and the NaturalPoint
registry key directly. That is the same family of integration used by
Nuclear Option.

## Unknowns

- Exact `NP_RegisterProgramProfileID` value used by Arma Reforger.
- Whether LinuxTrack's old game-data encryption table needs a new entry.
- Whether BattlEye changes behavior when `NPClient64.dll` is present in the
  game directory.
- Whether TrackIR support needs to be enabled in Arma settings before the DLL
  is loaded.

## Evidence Commands

```bash
strings -a "$HOME/.local/share/Steam/steamapps/common/Arma Reforger/ArmaReforgerSteam.exe" \
  | grep -Ei 'TrackIR|NPClient|NaturalPoint|NP_RegisterProgramProfileID'
```

```bash
find "$HOME/.local/share/Steam/steamapps/compatdata/1874880" \
  -iname NPClient.log -print
```

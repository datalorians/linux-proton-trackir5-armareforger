# Linux TrackIR 5 for Arma Reforger on Proton

Experimental local project for testing TrackIR 5 support in Arma Reforger on
Linux through Steam/Proton.

Status: **not tested yet**.

This project is intentionally separate from the Nuclear Option setup. Do not
publish or claim support until Arma Reforger has been launched and verified.

## What We Know

Installed Arma Reforger executable:

```text
~/.local/share/Steam/steamapps/common/Arma Reforger/ArmaReforgerSteam.exe
```

Steam app ID:

```text
1874880
```

Proton prefix:

```text
~/.local/share/Steam/steamapps/compatdata/1874880/pfx
```

Local executable strings show real TrackIR support:

```text
SetTrackIREnable
TrackIRYaw
TrackIRPitch
TrackIRRoll
NP_RegisterProgramProfileID
NPClient64.dll
Software\NaturalPoint\NATURALPOINT\NPClient Location
```

That strongly suggests Arma Reforger uses the same NaturalPoint `NPClient64.dll`
style bridge as Nuclear Option, but this must be tested.

## Test Plan

1. Install the bridge locally with `scripts/stage-bridge.sh`.
2. Launch Arma Reforger once with debug logging:

   ```bash
   LINUXTRACK_DBG=w %command%
   ```

3. Enable TrackIR in Arma Reforger settings.
4. Confirm:

   - LinuxTrack server starts.
   - TrackIR camera uploads firmware and reaches running state.
   - Arma responds to yaw/pitch/roll.
   - `F9` recenters and `F10` pauses/resumes.

5. Find `NPClient.log` and record the registered profile ID:

   ```bash
   find "$HOME/.local/share/Steam/steamapps/compatdata/1874880" \
     -iname NPClient.log -print
   ```

6. If the profile ID is unknown to LinuxTrack, add a proper Arma Reforger
   `gamedata.txt` entry and profile.

7. Only after verification, package/publish this project.

## Rollback

Run:

```bash
./scripts/rollback-bridge.sh
```

This removes the staged `NPClient*.dll` files and deletes the NaturalPoint
registry path from the Arma Reforger Proton prefix.

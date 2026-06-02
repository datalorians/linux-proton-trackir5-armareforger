# Notes

Arma Reforger uses NaturalPoint-style TrackIR integration through
`NPClient64.dll` under Proton.

Observed bridge calls during testing:

```text
RegisterProgramProfileID request: 8310
StartDataTransmission request
```

The game may default to very low TrackIR movement. Increase Arma Reforger's
in-game `TrackIR Freelook Sensitivity`; LinuxTrack may already be outputting a
full yaw/pitch range.

The patched bridge uses:

```text
/tmp/linuxtrack_npclient_center
/tmp/linuxtrack_npclient_pause
```

The patched LinuxTrack server mirrors pause state to the TrackIR 5 status LED.

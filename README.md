# Linux TrackIR 5 for Arma Reforger on Proton

Community setup notes and helper scripts for using a NaturalPoint TrackIR 5 kit
with Arma Reforger on Linux through Steam/Proton.

This repo packages a working LinuxTrack + Wine bridge setup:

- TrackIR 5 USB access through udev.
- LinuxTrack built from the maintained exuvo fork.
- A patched 64-bit `NPClient64.dll` Wine bridge for Proton games.
- Bridge-level F9/F10 recenter and pause support.
- TrackIR 5 pause LED feedback.
- Arma Reforger app ID/profile support.
- Optional X-55 HOTAS to Xbox 360 gamepad adapter for Arma Reforger helicopter
  controls.

It does not redistribute NaturalPoint firmware, the TrackIR Windows installer,
or proprietary NaturalPoint DLLs. You must provide/download the official
TrackIR installer yourself.

## Tested Setup

- TrackIR 5 camera: USB ID `131d:0158`
- TrackClip Pro
- Arma Reforger Steam app ID: `1874880`
- Arma Reforger NaturalPoint profile ID observed in-game: `8310`
- Proton prefix:
  `~/.local/share/Steam/steamapps/compatdata/1874880/pfx`
- Game directory:
  `~/.local/share/Steam/steamapps/common/Arma Reforger`
- Linux desktop: Cinnamon/X11

Other desktops should work for TrackIR itself, but global hotkeys may need a
different binding method.

## Quick Start

Install dependencies. On Debian/Ubuntu-like systems:

```bash
sudo apt install git build-essential autoconf automake libtool pkg-config \
  libusb-1.0-0-dev wine-staging-dev wine mono-utils
```

Clone and run the setup:

```bash
git clone https://github.com/datalorians/linux-proton-trackir5-armareforger.git
cd linux-proton-trackir5-armareforger
./scripts/install-linuxtrack.sh
./scripts/install-udev-rule.sh
```

Log out/in or replug the TrackIR after installing the udev rule.

Extract/install firmware and game data from the official TrackIR 5 Windows
installer. Then install the Arma Reforger profile and bridge:

```bash
./scripts/install-profile.sh
./scripts/build-wine-bridge.sh
./scripts/install-arma-reforger-bridge.sh
```

Install helper commands and optional Cinnamon hotkeys:

```bash
./scripts/install-helpers.sh
./scripts/install-cinnamon-hotkeys.sh
```

Launch Arma Reforger through Steam, enable TrackIR in the game settings, and
increase `TrackIR Freelook Sensitivity` if movement is tiny.

## In-Game Settings

Arma Reforger has its own TrackIR scaling. If LinuxTrack works but the in-game
view only moves a few degrees, this is usually the setting to fix.

Look for these in Arma Reforger settings:

- `TrackIR Enable`: on
- `TrackIR Freelook Enable`: on
- `TrackIR Freelook Sensitivity`: increase until the range feels right
- `TrackIR While ADS`: optional
- `TrackIR Freelook Deadzone ADS`: lower/zero for testing
- `TrackIR Leaning Active Yaw Range`: widen if leaning feels constrained

## Hotkeys

- `F9`: recenter view
- `F10`: pause/resume tracking and switch the TrackIR status LED to the paused
  color

Pause freezes the last pose returned to the game. It does not suspend the
LinuxTrack camera service.

## Steam Launch Option

TrackIR starts on demand when the game loads `NPClient64.dll`, so you do not
need a special Steam launch option for TrackIR.

For the optional X-55 adapter, use this launch option:

```bash
bash -lc '$HOME/.local/bin/x55-arma-reforger-virtual-gamepad & cleanup(){ $HOME/.local/bin/x55-arma-reforger-stop-virtual-gamepad; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

The adapter grabs the real X-55 stick/throttle and exposes one virtual
`Microsoft X-Box 360 pad`. This avoids Arma Reforger applying the built-in X56
Rhino preset to the X-55's different two-device axis layout.

Default helicopter mapping:

- X-55 stick X/Y: gamepad right stick X/Y for cyclic
- X-55 twist: gamepad left stick X for anti-torque/yaw
- X-55 split throttle average: gamepad left stick Y for collective

If an axis is backwards, prefix the launch option with one of these variables:

```bash
X55_REFORGER_INVERT_PITCH=0
X55_REFORGER_INVERT_COLLECTIVE=0
X55_REFORGER_INVERT_YAW=1
```

For debug logging, temporarily launch with:

```bash
LINUXTRACK_DBG=w %command%
```

The bridge writes `NPClient.log` in the game directory.

## Rollback

Run:

```bash
./scripts/rollback-bridge.sh
```

This removes the staged `NPClient*.dll` files and deletes the NaturalPoint
registry path from the Arma Reforger Proton prefix.

Stop the X-55 virtual gamepad manually with:

```bash
x55-arma-reforger-stop-virtual-gamepad
```

## Safety Notes

- Do not commit extracted firmware or proprietary NaturalPoint DLLs.
- Re-run `scripts/install-arma-reforger-bridge.sh` after changing Proton
  prefixes or moving the Steam library.
- Stop Arma Reforger before editing LinuxTrack profiles; LinuxTrack may save
  profile state on exit.

## License

Scripts and helper source in this repository are MIT licensed. LinuxTrack is a
separate project with its own license. NaturalPoint firmware/software is owned
by NaturalPoint and is not included here.

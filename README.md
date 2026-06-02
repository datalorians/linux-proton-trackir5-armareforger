# 🛰️ TrackIR 5 for Arma Reforger on Linux / Proton

Use a **NaturalPoint TrackIR 5** camera with **Arma Reforger** on Linux through
Steam/Proton.

This project packages the LinuxTrack + Proton bridge setup that makes Arma
Reforger see TrackIR as a normal NaturalPoint `NPClient64.dll` device.

## ✨ What This Does

- Builds LinuxTrack from the maintained `exuvo/linuxtrack` fork.
- Installs TrackIR 5 USB permissions through a udev rule.
- Adds an Arma Reforger LinuxTrack profile and NaturalPoint game ID entry.
- Builds and installs a Proton-compatible `NPClient64.dll` / `NPClient.dll`.
- Adds bridge-level recenter and pause/resume control.
- Mirrors pause state to the TrackIR 5 status LED, matching the familiar
  Windows TrackIR behavior.

## 🚫 What This Does Not Do

- It does not include NaturalPoint firmware, NaturalPoint software, or
  proprietary NaturalPoint DLLs.
- It does not require a Steam launch option for TrackIR.

## ✅ Tested Setup

| Item | Value |
| --- | --- |
| Game | Arma Reforger |
| Steam app ID | `1874880` |
| NaturalPoint profile ID observed | `8310` |
| TrackIR camera | TrackIR 5, USB ID `131d:0158` |
| Clip | TrackClip Pro |
| Proton prefix | `~/.local/share/Steam/steamapps/compatdata/1874880/pfx` |
| Game directory | `~/.local/share/Steam/steamapps/common/Arma Reforger` |
| Desktop tested | Cinnamon/X11 |

Other Linux desktops should work, but desktop-level shortcut setup may differ.

## 📦 Install

Install build dependencies first. On Debian/Ubuntu-like systems:

```bash
sudo apt install git build-essential autoconf automake libtool pkg-config \
  libusb-1.0-0-dev wine-staging-dev wine mono-utils
```

Clone this repo:

```bash
git clone https://github.com/datalorians/linux-proton-trackir5-armareforger.git
cd linux-proton-trackir5-armareforger
```

Build/install LinuxTrack and install the TrackIR 5 udev rule:

```bash
./scripts/install-linuxtrack.sh
./scripts/install-udev-rule.sh
```

Replug the TrackIR camera or log out/in after installing the udev rule.

LinuxTrack still needs the firmware/game data from the official TrackIR 5
Windows installer.

Install the Arma Reforger profile and Proton bridge:

```bash
./scripts/install-profile.sh
./scripts/build-wine-bridge.sh
./scripts/install-arma-reforger-bridge.sh
```

Install helper commands:

```bash
./scripts/install-helpers.sh
```

Optional Cinnamon/X11 shortcut installer:

```bash
./scripts/install-cinnamon-hotkeys.sh
```

## 🎮 Steam Setup

TrackIR starts when Arma Reforger loads the installed `NPClient64.dll`, so
TrackIR itself does **not** need a Steam launch option.

Launch the game normally through Steam, then enable TrackIR in Arma Reforger's
settings.

## 👀 In-Game TrackIR Settings

Arma Reforger has its own TrackIR scaling. If LinuxTrack is working but the
view only moves a few degrees, the in-game sensitivity is usually the fix.

Recommended settings to check:

- `TrackIR Enable`: on
- `TrackIR Freelook Enable`: on
- `TrackIR Freelook Sensitivity`: increase until range feels natural
- `TrackIR While ADS`: personal preference
- `TrackIR Freelook Deadzone ADS`: lower or zero for testing
- `TrackIR Leaning Active Yaw Range`: widen if leaning feels constrained

## ⌨️ Recenter and Pause Controls

The helper commands are:

```bash
trackir-linux-center
trackir-linux-toggle
trackir-linux-pause
trackir-linux-resume
```

The optional Cinnamon installer binds these to the classic TrackIR-style keys:

- `F9` for recenter
- `F10` for pause/resume

Those keys are not a special project feature; they are simply the familiar
Windows TrackIR defaults. You can bind any keys you want in your desktop
environment, keyboard utility, Stream Deck, joystick macro tool, or window
manager.

For example, bind:

```text
your preferred recenter key -> ~/.local/bin/trackir-linux-center
your preferred pause key    -> ~/.local/bin/trackir-linux-toggle
```

Pause freezes the last pose returned to the game and turns the TrackIR status
LED to the paused color. It does not shut down the camera service.

## 🧯 Troubleshooting

Debug launch option:

```bash
LINUXTRACK_DBG=w %command%
```

Debug log:

```text
~/.local/share/Steam/steamapps/common/Arma Reforger/NPClient.log
```

Rollback the installed bridge:

```bash
./scripts/rollback-bridge.sh
```

See [Notes](docs/notes.md) for observed bridge calls and local behavior.

## 🤖 AI Disclosure

This package was developed with assistance from OpenAI's Codex/ChatGPT. The
scripts, patches, and documentation were reviewed and tested locally before
publication, but they are community-maintained and provided as-is.

AI disclosure is separate from licensing: the disclosure explains how the work
was produced, while the license explains what rights you have to use and modify
the code.

## 📄 License

Repository scripts, helper source, and documentation are released under the
[MIT License](LICENSE).

LinuxTrack is a separate project with its own license. NaturalPoint firmware,
software, and trademarks belong to their respective owners and are not included
in this repository.

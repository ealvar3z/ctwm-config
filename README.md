# Portable CTWM Configuration

This is a portable CTWM setup modeled after NetBSD's default `system.ctwmrc`.
It supports NetBSD, FreeBSD, OpenBSD, Arch Linux, Debian/Ubuntu-style systems,
and a generic Linux fallback from one shared config and helper set.

The default theme keeps the NetBSD-like workspaces, colors, menus, font sizing,
mouse actions, and keyboard bindings. The `acme` theme adds the Plan 9
Acme-inspired palette from the old FreeBSD setup and can be used on any
supported platform.

## Install

Install the user config and helpers:

```sh
make install-user
```

This installs `~/.ctwmrc` and helper scripts under `~/.local/libexec/ctwm`.
Existing files are backed up with a timestamp when they differ.

Persist optional defaults:

```sh
make install-profile THEME=acme PLATFORM=freebsd
```

`THEME` may be `netbsd` or `acme`. `PLATFORM` may be `netbsd`, `freebsd`,
`openbsd`, `arch`, `debian`, or `linux`; omit it to auto-detect at CTWM
startup. Runtime environment variables override the profile file:

```sh
export CTWM_THEME=acme
export CTWM_PLATFORM=openbsd
exec ctwm
```

For `startx`, install the optional xinit template:

```sh
make install-xinit
```

For theme Xresources, install one of the templates:

```sh
make install-xresources THEME=acme
```

From a display manager, select the CTWM session supplied by your OS package.
For a minimal manual `~/.xinitrc`, `exec ctwm` is still enough.

## Packages

The base desktop needs CTWM, `xterm`, and GLib's `gio` command for safe XDG
desktop-file launching. Package names can vary slightly by release, but these
are the intended package sets:

| System | Required | Useful optional packages |
| --- | --- | --- |
| Arch | `sudo pacman -S ctwm glib2 xterm` | `dmenu mesa-utils sysstat vim wireplumber xcompmgr xorg-xcalc xorg-xedit xorg-xeyes xorg-xkill xorg-xmag xorg-xrandr xorg-xset xorg-xsetroot` |
| Debian/Ubuntu | `sudo apt install ctwm libglib2.0-bin xterm` | `dmenu mesa-utils sysstat vim wireplumber pulseaudio-utils x11-apps xcompmgr x11-xserver-utils` |
| FreeBSD | `sudo pkg install xorg ctwm xterm glib` | `dmenu mesa-demos sysstat vim xcompmgr xcalc xedit xeyes xkill xmag xrandr xsetroot xclock plan9port` |
| NetBSD/pkgsrc | `sudo pkgin install ctwm glib2 xterm` | `dmenu mesa-demos sysstat vim xcompmgr xcalc xedit xeyes xkill xmag plan9port` |
| OpenBSD | `doas pkg_add ctwm glib2 xterm` | `dmenu mesa-demos vim xcompmgr plan9port` |

Optional menu entries simply fail to launch if their command is not installed.
The generated XDG application menu is available when `gio` is installed.
Volume keys use the first available backend among `wpctl`, `pactl`, `sndioctl`,
`mixerctl`, and `mixer`.

## Themes

`netbsd` is the default. It uses numbered workspaces and the NetBSD-derived
lavender/firebrick palette.

`acme` uses:

- body background `#FFFFEA`
- body selection `#EEEE9E`
- body border/accent `#99994C`
- tag/title background `#EAFFFF`
- tag selection `#9EEEEE`
- tag/title border `#8888CC`
- text `#000000`

When Plan 9 tools are installed, CTWM detects them at startup and adds Acme,
Sam, plumber, and rc shell menu entries where the commands are available.

## Fonts

At startup, `ctwm_font_size` selects a bitmap font size from the primary
monitor reported by `xrandr`, avoiding multi-monitor scaling mistakes.

`ctwm_font_path` uses Spleen when installed. It searches common Linux, FreeBSD,
NetBSD/pkgsrc, and OpenBSD font roots, then builds an indexed font cache under
`~/.cache/ctwm/fonts/spleen`. Set `CTWM_SPLEEN_DIR` to force a specific source
directory. When Spleen or X11 font indexing tools are unavailable, the config
falls back to standard X bitmap font aliases.

## Terminal Selection

All terminal shortcuts and `Terminal=true` desktop entries use
`ctwm_terminal`. It selects a terminal in this order:

1. `CTWM_TERMINAL`
2. `TERMINAL`
3. the active terminal identified by environment markers from kitty,
   Alacritty, WezTerm, foot, urxvt, Konsole, GNOME Terminal, or Tilix
4. `x-terminal-emulator`, `xterm`, or `uxterm`

Preference variables must contain an executable name or path, without extra
options. The helper handles the different command-execution conventions used
by common terminal emulators.

Run `make check` after editing to check helper syntax, font-size heuristics,
profile precedence, m4 preprocessing across every supported platform/theme
pair, and CTWM syntax when `ctwm` is installed.

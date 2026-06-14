# NetBSD ctwm configuration for Arch Linux

This is NetBSD's default ctwm configuration adapted for Arch Linux. It keeps
the window decorations, colors, workspaces, DPI-aware font sizing, generated
application menus, mouse actions, and keyboard bindings.

## Install

Install the required packages:

```sh
sudo pacman -S ctwm glib2 xterm
```

Install the configuration as `~/.ctwmrc`:

```sh
make install-user
```

The install target writes the helper scripts to `~/.local/libexec/ctwm` and
creates a timestamped backup when `~/.ctwmrc` already exists and differs from
this configuration.

From a display manager, select the **ctwm** session installed by the Arch
package. To start ctwm with `startx`, put this in `~/.xinitrc`:

```sh
exec ctwm
```

## Optional menu commands

The base desktop works with only `ctwm` and `xterm`. Install these packages to
enable all menu entries and multimedia keys:

```sh
sudo pacman -S \
  alsa-utils dmenu mesa-utils sysstat vim wireplumber xcompmgr \
  xorg-xcalc xorg-xedit xorg-xeyes xorg-xkill xorg-xmag
```

`wireplumber` supplies `wpctl`, which controls PipeWire volume. The application
menu is generated from the user and system XDG application directories.
`glib2` supplies `gio`, which launches desktop files without interpreting their
`Exec=` values as shell commands. `dmenu_run` remains available as an optional
fallback launcher.

## Spleen fonts

The configuration uses Spleen when the `spleen-font` AUR package is installed.
Install the X11 font indexing utilities as well:

```sh
sudo pacman -S xorg-mkfontscale xorg-xset
# Install spleen-font from the AUR with your preferred AUR workflow.
```

At startup, `ctwm_font_path` builds an indexed font directory under
`~/.cache/ctwm/fonts/spleen` and adds it to the current X server font path.
When Spleen or the indexing tools are unavailable, the configuration falls
back to bitmap fonts supplied by `xorg-fonts-misc`.

`ctwm_font_size` uses the primary monitor reported by `xrandr`, avoiding the
incorrect scaling that can result from treating a multi-monitor desktop as one
large display.

## Terminal selection

All terminal shortcuts and `Terminal=true` desktop entries use
`ctwm_terminal`. It selects a terminal in this order:

1. `CTWM_TERMINAL`
2. `TERMINAL`
3. The active terminal identified by environment markers from kitty,
   Alacritty, WezTerm, foot, urxvt, Konsole, GNOME Terminal, or Tilix
4. `xterm`

Set the preference to an executable name or path before starting ctwm:

```sh
export TERMINAL=alacritty
exec ctwm
```

Use `CTWM_TERMINAL` when the preference should apply only to this
configuration. The helper handles the different command-execution conventions
used by xterm, urxvt, kitty, Alacritty, and other common emulators. Preference
variables must contain an executable name or path, without additional options.

Run `make check` after editing to check the helper scripts, font-size
heuristics, m4 preprocessing, and ctwm syntax when ctwm is installed.

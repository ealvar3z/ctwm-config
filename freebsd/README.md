# CTWM Acme Desktop for FreeBSD

This is a small X11 desktop for FreeBSD using CTWM and a Plan 9 Acme-inspired palette.

## Palette

- Body background: `#FFFFEA`
- Body selection: `#EEEE9E`
- Body border/accent: `#99994C`
- Tag/title background: `#EAFFFF`
- Tag selection: `#9EEEEE`
- Tag/title border: `#8888CC`
- Text: `#000000`

## Install

As root:

```sh
sh root-setup.sh yourusername
```

Then reboot if you set a GPU module. As your normal user:

```sh
sh install-user-files.sh
startx
```

## Keys

- `Alt-Return`: terminal
- `Alt-a`: Acme
- `Alt-m`: root menu
- `Alt-w`: window menu
- `Alt-n` / `Alt-p`: next / previous workspace
- `Alt-Tab`: next window
- `Alt-f`: full zoom
- `Alt-i`: iconify
- `Ctrl-Alt-r`: restart CTWM
- `Ctrl-Alt-q`: quit X session

## Notes

CTWM controls the shell, decorations, menu, workspace manager, and icon manager. It cannot force every X11 application to use Acme colors internally. Xterm is configured to use the Acme body color, and CTWM title/menu/workspace surfaces use the Acme tag color.

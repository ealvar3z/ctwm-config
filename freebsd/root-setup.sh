#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
        echo "run as root" >&2
        exit 1
fi

USER_TO_ADD=${1:-}
if [ -z "$USER_TO_ADD" ]; then
        echo "usage: sh root-setup.sh username" >&2
        exit 1
fi

pkg update
pkg install -y xorg ctwm xterm xrandr xsetroot xmessage xclock xclip dbus drm-kmod dejavu liberation-fonts terminus-font plan9port

pw groupmod video -m "$USER_TO_ADD" || true
sysrc dbus_enable=YES
service dbus start || true

cat <<'MSG'

Root setup complete.

GPU note:
  For Intel/AMD graphics, FreeBSD usually needs drm-kmod loaded at boot.
  Inspect your GPU with:
      pciconf -lv | grep -B3 -A3 -E 'VGA|3D|Display'

  Common examples:
      sysrc kld_list+=i915kms      # Intel
      sysrc kld_list+=amdgpu       # AMD

Reboot after setting the GPU module, then log in as your normal user and run:
      sh install-user-files.sh
      startx
MSG

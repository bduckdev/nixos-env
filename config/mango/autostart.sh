  #!/usr/bin/env sh
  set -eu

  dbus-update-activation-environment --systemd \
    DISPLAY \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP \
    XDG_SESSION_TYPE \
    XCURSOR_THEME \
    XCURSOR_SIZE \
    MANGO_INSTANCE_SIGNATURE

  systemctl --user reset-failed
  systemctl --user start mango-session.target



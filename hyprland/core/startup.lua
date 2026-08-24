-- core/startup.lua
-- Migrated from core/startup.conf

-- env = VAR, value  ->  hl.env(VAR, value)
hl.env("XCURSOR_THEME", "Oxygen-06-Magenta")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- exec-once = ...  ->  run inside the hyprland.start hook.
-- The official example uses hl.exec_cmd() (not hl.dsp.exec_cmd, which is
-- the dispatcher used *inside* a keybind) for one-shot startup commands.
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hyprctl setcursor Oxygen-06-Magenta 24")
  hl.exec_cmd("hypridle &")
  hl.exec_cmd("nm-applet &")
  hl.exec_cmd("tailscale systray &")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("fcitx5 -d --replace")
  hl.exec_cmd("awww query || awww-daemon")
  hl.exec_cmd("xrandr --output DP-1 --primary")
  hl.exec_cmd("easyeffects --gapplication-service &")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("QML_XHR_ALLOW_FILE_READ=1 qs -c axiom")
  -- hl.exec_cmd("youtube-music &")
  -- hl.exec_cmd("mullvad-vpn &")
  -- hl.exec_cmd("element-desktop &")
  hl.exec_cmd("protonmail-bridge --no-window &")
  hl.exec_cmd("gtk-launch deej")
end)

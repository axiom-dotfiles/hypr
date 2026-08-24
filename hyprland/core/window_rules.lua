-- core/windowrules.lua
-- Migrated from your commented-out windowrule / windowrulev2 block.
--
-- Since Hyprland v0.55, window rules use hl.window_rule({ match = {...},
-- ...effects }). Rules are evaluated top to bottom, so order matters --
-- kept in the same order as your original block.
--
-- CONFIDENCE NOTES (read once, applies throughout this file):
--   Confirmed by the official wiki / example config: match.class,
--   match.title (both RE2 regex), float (prop + effect), fullscreen
--   (prop), pin (prop + effect), xwayland (prop), no_blur, rounding,
--   opacity (string, same "ACTIVE INACTIVE [FULLSCREEN] [override]"
--   format as before), border_color, move ({x,y} table OR a formula
--   string using monitor_w/h, window_w/h, cursor_x/y), size (same,
--   {w,h} table or a formula/percent string), animation, suppress_event
--   (single event name string, e.g. "activatefocus", "maximize").
--   INFERRED, not found documented anywhere -- test these specifically:
--   pseudo = true, tile = true, fullscreen = true as an *effect*
--   (confirmed only as a match prop). workspace = "..." assigns a
--   newly-matched window to a workspace -- CONFIRMED, but there is no
--   separate `silent` field: the "silent" modifier is part of the same
--   string, exactly like the old rule value, e.g.
--   workspace = "special:special silent".
--   There's also no confirmed dedicated "center" effect, so screen-
--   centering below uses the same move-formula trick the wiki uses for
--   cursor-centering.

-- fcitx
hl.window_rule({ match = { class = "fcitx" }, pseudo = true }) -- TODO: verify pseudo effect name

-- Simple float-only utilities
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { class = "nwg-look|qt5ct" }, float = true })
hl.window_rule({ match = { class = "mpv" }, float = true })

-- Float + fixed-percent size utilities
hl.window_rule({ match = { class = "org.gnome.Settings" }, float = true, size = "35% 50%" })
hl.window_rule({ match = { class = "nemo" }, float = true, size = "35% 50%" })
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, size = "35% 50%" })
hl.window_rule({ match = { class = "^(.*blueberry.*)$" }, float = true, size = "35% 50%" })
hl.window_rule({ match = { class = "^(.*qimgv.*)$" }, float = true, size = "35% 50%" })
hl.window_rule({ match = { class = "easyeffects" }, float = true, size = "35% 50%" })

-- pavucontrol: volume popup gets a fixed pixel size, other pavucontrol
-- windows just get centered
hl.window_rule({
  match = { class = "org.pulseaudio.pavucontrol", title = ".*Volume.*" },
  float = true,
  size = { 1120, 721 },
})
hl.window_rule({
  match = { class = "^(pavucontrol)$" },
  -- TODO: no confirmed "center" effect -- using the wiki's move-formula
  -- pattern for screen-centering instead.
  move = { "monitor_w/2 - window_w/2", "monitor_h/2 - window_h/2" },
})

-- Bitwarden: float + center
hl.window_rule({
  match = { class = "^(.*[Bb]itwarden.*)$" },
  float = true,
  move = { "monitor_w/2 - window_w/2", "monitor_h/2 - window_h/2" },
})

-- gamescope
hl.window_rule({
  match = { class = "gamescope" },
  no_blur = true,
  fullscreen = true, -- TODO: confirmed as a match prop, not confirmed as an effect
  -- workspace = "special silent",
})

-- Opacity overrides
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "1 1" })
hl.window_rule({ match = { title = "^(btop)$" }, opacity = "1 override 1 override" })
hl.window_rule({ match = { title = "^(.*KiCad.*)$" }, opacity = "1 override 1 override" })

-- Make steam subwindows float, keep the main window tiled
hl.window_rule({ match = { class = "^steam$" }, float = true, size = "45% 60%" })
hl.window_rule({
  match = { class = "^steam$", title = "^Steam$" },
  tile = true, -- TODO: unconfirmed effect name (inverse of float=true)
})
hl.window_rule({ match = { title = "^Steam$" }, suppress_event = "activatefocus" })

-- Picture-in-Picture
hl.window_rule({
  match = { title = "^(Picture-in-Picture)$" },
  opacity = "0.95 0.75",
  pin = true,
  float = true,
  size = "25% 25%",
  move = "72% 7%",
})

-- Spotify: float into the special workspace at a fixed position/size
hl.window_rule({
  match = { class = "^(Spotify)$" },
  workspace = "special:special silent",
  move = { 1765, 100 },
  size = { 1650, 1150 },
})

-- YouTube Music: same treatment as Spotify
hl.window_rule({
  match = { class = "^(com.github.th_ch.youtube_music)$" },
  workspace = "special:special silent",
  move = { 1765, 100 },
  size = { 1650, 1150 },
})

-- Element
hl.window_rule({
  match = { class = "^(Element)$" },
  workspace = "special:special silent",
  move = { 69, 100 },
  size = { 1650, 1150 },
})

-- Signal
hl.window_rule({
  match = { class = "^(signal)$" },
  workspace = "special:special silent",
  move = { 159, 142 },
  size = { 1315, 951 },
})

-- OpenLens -> its own special workspace, no size/position change
hl.window_rule({
  match = { class = "^(OpenLens)$" },
  workspace = "special:lens silent",
})

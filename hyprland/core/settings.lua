-- core/settings.lua
-- Migrated from core/settings.conf

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 3,
    resize_on_border = true,
    col = {
      active_border = "rgb(bb9af7)",
      inactive_border = "rgb(7dcfff)",
    },
    layout = "dwindle",
  },

  dwindle = {
    preserve_split = true,
    smart_split = false,
    smart_resizing = true,
  },

  decoration = {
    rounding = 4,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    dim_inactive = true,
    dim_strength = 0.08,
    blur = {
      enabled = true,
      size = 4,
      passes = 3,
      xray = true,
      ignore_opacity = true,
      new_optimizations = true,
    },
  },

  animations = {
    enabled = true,
  },

  input = {
    kb_layout = "us",
    repeat_rate = 50,
    repeat_delay = 300,
    numlock_by_default = 1,
    left_handed = 0,
    follow_mouse = 1,
    float_switch_override_focus = 0,
    accel_profile = "flat",
  },

  -- NOTE: `binds { }` and `xwayland { }` weren't shown in the official
  -- example config, so these two blocks are inferred from the same
  -- nested-table pattern the rest of hl.config() uses. If Hyprland
  -- complains about either on reload, check the wiki's Variables page
  -- for the confirmed 0.55 key names.
  binds = {
    scroll_event_delay = 0,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    enable_swallow = true,
    focus_on_activate = true,
    swallow_regex = "^(kitty)$",
  },
})

-- Bezier curves
-- bezier = name, x1, y1, x2, y2  ->  hl.curve(name, { type = "bezier", points = { {x1,y1}, {x2,y2} } })
hl.curve("myBezier",   { type = "bezier", points = { {0.05, 0.9},  {0.1, 1} } })
hl.curve("linear",     { type = "bezier", points = { {0.0, 0.0},   {1.0, 1.0} } })
hl.curve("wind",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1} } })
hl.curve("winIn",      { type = "bezier", points = { {0.1, 1.1},   {0.1, 1} } })
hl.curve("winOut",     { type = "bezier", points = { {0.3, -0.3},  {0, 1} } })
hl.curve("slow",       { type = "bezier", points = { {0, 0.85},    {0.3, 1} } })
hl.curve("overshot",   { type = "bezier", points = { {0.7, 0.6},   {0.1, 1.1} } })
hl.curve("bounce",     { type = "bezier", points = { {1.1, 1.6},   {0.1, 0.85} } })
hl.curve("slingshot",  { type = "bezier", points = { {1, -1},      {0.15, 1.25} } })
hl.curve("nice",       { type = "bezier", points = { {0, 2.00},     {0.5, -1} } })
hl.curve("md3_decel",  { type = "bezier", points = { {0.05, 0.7},  {0.1, 1} } })

-- Animations
-- animation = leaf, onoff, speed, curve, [style]
hl.animation({ leaf = "windowsIn",       enabled = true, speed = 0.5, bezier = "slow",      style = "popin" })
hl.animation({ leaf = "windowsOut",      enabled = true, speed = 0.5, bezier = "winOut",    style = "popin" })
hl.animation({ leaf = "windowsMove",     enabled = true, speed = 0.7, bezier = "wind",      style = "slide" })
hl.animation({ leaf = "fade",            enabled = true, speed = 2,   bezier = "overshot" })
hl.animation({ leaf = "workspaces",      enabled = true, speed = 2.5, bezier = "wind",      style = "fade" })
hl.animation({ leaf = "windows",         enabled = true, speed = 2,   bezier = "bounce",    style = "popin" })
hl.animation({ leaf = "specialWorkspace",enabled = true, speed = 0.8, bezier = "md3_decel", style = "slidevert" })

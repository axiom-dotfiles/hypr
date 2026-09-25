-- 10-monitors.lua

-- Fallback for any output without a rule below
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

hl.monitor({ output = "DP-1", mode = "3440x1440@240", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "3440x1440@144", position = "-1440x-1100", scale = 1, transform = 3 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-2", mode = "3840x2160@60", position = "0x0", scale = 1 })

-- Start in the middle of the axiom workspace grid
hl.workspace_rule({
  workspace = 13,
  monitor = "DP-1",
  default = true,
})

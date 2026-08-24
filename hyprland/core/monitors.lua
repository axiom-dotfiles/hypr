-- core/monitors.lua
-- Migrated from core/monitors.conf

-- monitor = ,preferred,auto,1
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

-- workspace = 13, monitor:, default:true
hl.workspace_rule({
  workspace = 13,
  monitor = "",
  default = true,
})

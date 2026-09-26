-- 30-startup.lua: what axiom's settings don't cover. Environment variables
-- and autostart commands are in axiom: Settings → Hyprland → Startup, and
-- settings, animations and keybinds in the other Hyprland cards and the
-- Keybinds page.

hl.on("hyprland.start", function()
  -- Start in the middle of the grid. A plain dispatch: axiom (and its
  -- workspaces IPC) is still starting at this point.
  hl.dispatch(hl.dsp.focus({ workspace = 13 }))
end)

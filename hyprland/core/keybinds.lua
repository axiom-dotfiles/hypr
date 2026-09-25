-- core/keybinds.lua
-- Migrated from core/keybinds.conf
--
-- A few dispatchers below have NO direct example in Hyprland's official
-- hyprland.lua template, so I've marked each one with -- TODO: verify.
-- Those are educated guesses at the naming pattern (hl.dsp.*), not
-- confirmed. Everything else (hl.dsp.exec_cmd, window.close,
-- window.float toggle, window.pseudo, layout("togglesplit"),
-- focus({direction=...}), window.move({workspace=...}),
-- workspace.toggle_special, window.drag/resize with {mouse=true},
-- and the {locked, repeating} bind options) is taken directly from
-- Hyprland's official example config, so those are safe as-is.

local vars = require("hyprland.core.variables")
local mod  = vars.mod
local mod2 = vars.mod2

-- {{ WINDOW }}
-- Window Management
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(vars.scripts .. "/rotateMonitor.sh"), { description = "Window: Rotate monitor" })
-- Move focus
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }), { description = "Window: Focus left" })
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }), { description = "Window: Focus down" })
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }), { description = "Window: Focus up" })
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }), { description = "Window: Focus right" })
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Window: Focus left" })
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Window: Focus down" })
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Window: Focus up" })
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Window: Focus right" })

-- Move window
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }), { description = "Window: Move left" })
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }), { description = "Window: Move down" })
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }), { description = "Window: Move up" })
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }), { description = "Window: Move right" })
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }), { description = "Window: Move left" })
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }), { description = "Window: Move down" })
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }), { description = "Window: Move up" })
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }), { description = "Window: Move right" })

-- Full
hl.bind(mod .. " + f", hl.dsp.window.fullscreen(), { description = "Window: Fullscreen" })
hl.bind(mod .. " + c", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind(mod .. " + z", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating" })
-- hl.bind(mod .. " + x", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg"))
-- hl.bind(mod2 .. " + s", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg"))

-- {{ WORKSPACE }}
-- Navigation goes through axiom (vars.axiom_ws), so it follows the layout
-- set in axiom's Workspaces settings (grid size, per-monitor ranges, wrap,
-- directional slides) instead of being hardcoded here.
local ws = vars.axiom_ws

-- WASD Motions
hl.bind(mod .. " + a", hl.dsp.exec_cmd(ws .. "left"), { description = "Workspace: Switch left" })
hl.bind(mod .. " + d", hl.dsp.exec_cmd(ws .. "right"), { description = "Workspace: Switch right" })
hl.bind(mod .. " + w", hl.dsp.exec_cmd(ws .. "up"), { description = "Workspace: Switch up" })
hl.bind(mod .. " + s", hl.dsp.exec_cmd(ws .. "down"), { description = "Workspace: Switch down" })

-- WASD Move Window
hl.bind(mod .. " + SHIFT + a", hl.dsp.exec_cmd(ws .. "step left move"), { description = "Workspace: Move window left" })
hl.bind(mod .. " + SHIFT + d", hl.dsp.exec_cmd(ws .. "step right move"), { description = "Workspace: Move window right" })
hl.bind(mod .. " + SHIFT + w", hl.dsp.exec_cmd(ws .. "step up move"), { description = "Workspace: Move window up" })
hl.bind(mod .. " + SHIFT + s", hl.dsp.exec_cmd(ws .. "step down move"), { description = "Workspace: Move window down" })

-- VIM Motions
hl.bind(mod2 .. " + j", hl.dsp.exec_cmd(ws .. "down"), { description = "Workspace: Switch down" })
hl.bind(mod2 .. " + k", hl.dsp.exec_cmd(ws .. "up"), { description = "Workspace: Switch up" })
hl.bind(mod2 .. " + h", hl.dsp.exec_cmd(ws .. "left"), { description = "Workspace: Switch left" })
hl.bind(mod2 .. " + l", hl.dsp.exec_cmd(ws .. "right"), { description = "Workspace: Switch right" })

-- VIM Move Window
hl.bind(mod2 .. " + SHIFT + j", hl.dsp.exec_cmd(ws .. "step down move"), { description = "Workspace: Move window down" })
hl.bind(mod2 .. " + SHIFT + k", hl.dsp.exec_cmd(ws .. "step up move"), { description = "Workspace: Move window up" })
hl.bind(mod2 .. " + SHIFT + h", hl.dsp.exec_cmd(ws .. "step left move"), { description = "Workspace: Move window left" })
hl.bind(mod2 .. " + SHIFT + l", hl.dsp.exec_cmd(ws .. "step right move"), { description = "Workspace: Move window right" })

-- Switch directly to workspace: the n-th of the current grid row (or
-- workspace n in axiom's standard layout)
for i = 1, 5 do
  hl.bind(mod .. " + " .. i, hl.dsp.exec_cmd(ws .. "nth " .. i .. " go"), { description = "Workspace: Go to workspace " .. i })
end

-- Switch directly to workspace and bring window
for i = 1, 5 do
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.exec_cmd(ws .. "nth " .. i .. " move"), { description = "Workspace: Move window to workspace " .. i })
end

-- Move window to workspace (silent)
-- NOTE: these reuse the mod + arrow-key combos already bound to movefocus
-- above. In your original .conf, a later duplicate bind overrides the
-- earlier one, so these silent-move binds are the ones that actually fire
-- for mod+arrows. Kept the same override order here.
hl.bind(mod .. " + up", hl.dsp.exec_cmd(ws .. "step up moveSilent"), { description = "Workspace: Move window up (silent)" })
hl.bind(mod .. " + down", hl.dsp.exec_cmd(ws .. "step down moveSilent"), { description = "Workspace: Move window down (silent)" })
hl.bind(mod .. " + left", hl.dsp.exec_cmd(ws .. "step left moveSilent"), { description = "Workspace: Move window left (silent)" })
hl.bind(mod .. " + right", hl.dsp.exec_cmd(ws .. "step right moveSilent"), { description = "Workspace: Move window right (silent)" })

-- Resize Layouts
hl.bind(mod .. " + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true}), { repeating = true, description = "Window: Shrink width" })
hl.bind(mod .. " + CTRL + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true}), { repeating = true, description = "Window: Grow width" })
hl.bind(mod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true}), { repeating = true, description = "Window: Grow height" })
hl.bind(mod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true}), { repeating = true, description = "Window: Shrink height" })

-- hl.bind(mod .. " + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"), { repeating = true })
-- hl.bind(mod .. " + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"), { repeating = true })
-- hl.bind(mod .. " + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"), { repeating = true })
-- hl.bind(mod .. " + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"), { repeating = true })

-- hl.bind(mod .. " + CTRL + w", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"), { repeating = true })
-- hl.bind(mod .. " + CTRL + a", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"), { repeating = true })
-- hl.bind(mod .. " + CTRL + s", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"), { repeating = true })
-- hl.bind(mod .. " + CTRL + d", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"), { repeating = true })

-- {{ OTHER }}
-- Axiom
-- `bindr` (fires on key release) -> guessed as { on_release = true }.
-- TODO: verify the exact option name against the wiki's Binds page.
hl.bind(mod .. " + CTRL + r", hl.dsp.exec_cmd(vars.axiom_restart), { on_release = true, description = "Axiom: Restart shell" })
hl.bind(mod .. " + SHIFT + space", hl.dsp.exec_cmd(vars.axiom_workspace), { description = "Axiom: Workspace overlay" })
hl.bind(mod .. " + space", hl.dsp.exec_cmd(vars.axiom_launch), { description = "Axiom: App launcher" })
hl.bind(mod .. " + m", hl.dsp.exec_cmd(vars.axiom_overlay), { description = "Axiom: Overlay" })

-- Mouse Controls
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Drag" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })

-- Special workspaces
hl.bind(mod .. " + g", hl.dsp.workspace.toggle_special("gaming"), { description = "Special: Toggle gaming" })
hl.bind(mod .. " + SHIFT + g", hl.dsp.window.move({ workspace = "special:gaming" }), { description = "Special: Move window to gaming" })
hl.bind(mod .. " + v", hl.dsp.workspace.toggle_special("special"), { description = "Special: Toggle scratchpad" })
hl.bind(mod .. " + SHIFT + v", hl.dsp.window.move({ workspace = "special:special" }), { description = "Special: Move window to scratchpad" })

-- Application Launchers
hl.bind(mod .. " + q", hl.dsp.exec_cmd(vars.terminal), { description = "Apps: Terminal" })
hl.bind(mod .. " + SHIFT + q", hl.dsp.exec_cmd(vars.browser), { description = "Apps: Browser" })
hl.bind(mod .. " + e", hl.dsp.exec_cmd(vars.files), { description = "Apps: File manager" })
hl.bind(mod .. " + t", hl.dsp.exec_cmd(vars.task), { description = "Apps: Task manager" })
hl.bind(mod .. " + b", hl.dsp.exec_cmd(vars.mixer), { description = "Apps: Audio mixer" })
hl.bind(mod .. " + SHIFT + c", hl.dsp.exec_cmd(vars.chat), { description = "Apps: Chat" })
hl.bind(mod .. " + SHIFT + e", hl.dsp.exec_cmd(vars.discord), { description = "Apps: Discord" })
hl.bind(mod .. " + CTRL + s", hl.dsp.exec_cmd(vars.screenshot), { description = "Apps: Screenshot" })
hl.bind(mod .. " + SHIFT + CTRL + s", hl.dsp.exec_cmd(vars.screenshot_clipboard), { description = "Apps: Screenshot to OCR" })

-- Media Controls
--hl.bind("XF86AudioPlayPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: Play/Pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: Play/Pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Media: Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Media: Previous track" })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true, description = "Media: Stop" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("playerctl --player=spotify volume 0.05+"),
  { locked = true, repeating = true, description = "Media: Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("playerctl --player=spotify volume 0.05-"),
  { locked = true, repeating = true, description = "Media: Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true, repeating = true, description = "Media: Toggle mic mute" })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(vars.scripts .. "/brightness.sh inc"), { locked = true, repeating = true, description = "System: Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(vars.scripts .. "/brightness.sh dec"),
  { locked = true, repeating = true, description = "System: Brightness down" })

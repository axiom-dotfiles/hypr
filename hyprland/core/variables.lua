-- core/variables.lua
-- Migrated from core/variables.conf
--
-- hyprlang $variables were just text substitution, valid anywhere after
-- they were defined. In Lua there's no global substitution, so this file
-- returns a plain table (`M`) and every other file does:
--   local vars = require("hyprland.core.variables")
-- then uses vars.mod, vars.terminal, etc.
--
-- The one variable that was a real environment variable (XDG_CONFIG_HOME)
-- still needs hl.env(), since that's what actually exports it to child
-- processes -- a Lua local wouldn't do that.

local home = os.getenv("HOME")

hl.env("XDG_CONFIG_HOME", home .. "/.config")

local M = {}

M.scripts = home .. "/.config/hypr/scripts"

-- Axiom
M.axiom           = "qs -c axiom"
M.axiom_start     = "QML_XHR_ALLOW_FILE_READ=1 " .. M.axiom .. " &"
M.axiom_kill      = "qs kill -c axiom"
M.axiom_restart   = M.axiom_kill .. "; " .. M.axiom_start
M.axiom_launch    = M.axiom .. " ipc call appLauncher toggle"
M.axiom_overlay   = M.axiom .. " ipc call overlay toggle"
M.axiom_workspace = M.axiom .. " ipc call workspaceOverlay toggle"

-- Modifiers
M.mod  = "SUPER"
M.mod2 = "ALT"

-- Programs
M.terminal = "kitty"
M.browser  = "firefox"
M.editor   = "nvim"
M.chat     = "element-desktop"
M.discord  = "vesktop"
M.steam    = "steam"
M.music    = "spotify"
M.video    = "vlc"
M.files    = "nemo"
M.task     = 'kitty --title "btop" -e btop'
M.mixer    = "pavucontrol"

-- Screenshots
M.screenshot           = M.scripts .. "/grimblast.sh --freeze copy area"
M.screenshot_clipboard = "rm -f /tmp/ocr-input.png && rm -f /tmp/ocr-done && " .. M.scripts .. "/grimblast.sh --freeze save area /tmp/ocr-input.png"

return M

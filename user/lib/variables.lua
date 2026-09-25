-- lib/variables.lua: shared values, for `local vars = require("user.lib.variables")`.
-- Lives in lib/ so axiom's hyprland.lua doesn't load it as a config file.

local home = os.getenv("HOME")

hl.env("XDG_CONFIG_HOME", home .. "/.config")

local M = {}

M.scripts = home .. "/.config/hypr/user/scripts"

-- Axiom (its own keybinds live in axiom's settings: Desktop → Hyprland)
M.axiom_restart = "qs kill -c axiom; qs -c axiom &"

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

-- core/windowrules.lua

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

-- Opacity overrides
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "1 1" })
hl.window_rule({ match = { title = "^(btop)$" }, opacity = "1 override 1 override" })
hl.window_rule({ match = { title = "^(.*KiCad.*)$" }, opacity = "1 override 1 override" })

-- Make steam subwindows float, keep the main window tiled
hl.window_rule({ match = { class = "^steam$" }, float = true, size = "45% 60%" })
hl.window_rule({
  match = { class = "^steam$", title = "^Steam$" },
  tile = true,
})
hl.window_rule({ match = { title = "^Steam$" }, suppress_event = "activatefocus" })

-- gamescope: pin to the special "gaming" workspace instead of wherever it opens
hl.window_rule({
  match = { class = "gamescope" },
  no_blur = true,
  fullscreen = true, -- TODO: confirmed as a match prop, not confirmed as an effect
  workspace = "special:gaming",
})

local GAME_CLASS_PATTERNS = { "^cs2$", "^steam_app_%d+$" }
local GAME_WORKSPACE = "special:gaming"

-- Static class-pattern matches: these can be expressed directly as
-- declarative window rules.
for _, pat in ipairs(GAME_CLASS_PATTERNS) do
  hl.window_rule({
    match = { class = pat },
    workspace = GAME_WORKSPACE,
  })
end

-- Returns the Steam app id (string) if the process was launched by Steam,
-- else nil.
local function steamAppIdOf(pid)
  if not pid or pid <= 0 then
    return nil
  end
  local f = io.open("/proc/" .. pid .. "/environ", "rb")
  if not f then
    return nil
  end
  local env = f:read("a") or ""
  f:close()
  -- NUL-separated; anchor on the separator (or start) so e.g.
  -- FOO_SteamAppId= wouldn't match.
  return env:match("\0SteamAppId=(%d+)") or env:match("^SteamAppId=(%d+)")
end

local function isGameWindow(w)
  if not w then
    return false
  end
  if w.content_type == "game" then
    return true
  end
  local cls = w.class or ""
  for _, pat in ipairs(GAME_CLASS_PATTERNS) do
    if cls:match(pat) then
      return true
    end
  end
  return steamAppIdOf(w.pid) ~= nil
end

-- Dynamic check (content_type == "game" / SteamAppId env var): these can't
-- be expressed as a static "match" table since they depend on runtime
-- process info, so hook window-open and dispatch a move for any match.
hl.on("window.open", function(w)
    if isGameWindow(w) then
        hl.dispatch(hl.dsp.window.move({ workspace = GAME_WORKSPACE, window = w }))
    end
end)

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

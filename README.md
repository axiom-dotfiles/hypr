# hypr

My Hyprland extensions for an [axiom](https://github.com/axiom-dotfiles/axiom)-managed setup.

axiom's Hyprland mode is **managed**, so axiom writes `~/.config/hypr/hyprland.lua` itself. That file covers:
- axiom's keybinds: launcher, overlay, and workspace navigation
- layout, gaps, borders (in theme colours), blur, input and the cursor
- starting the shell

All of that is edited in axiom, under Settings → Desktop → Hyprland.

Everything else is here, in `user/`. `~/.config/hypr/user` is a symlink to it, and axiom's `hyprland.lua` loads it after its own settings, so anything here wins:

| File | What |
| --- | --- |
| `10-monitors.lua` | Monitors, and workspace 13 on DP-1 |
| `20-settings.lua` | Options axiom doesn't cover (misc, swallow, beziers and animations) |
| `30-startup.lua` | Environment and autostart |
| `40-keybinds.lua` | Window management, apps, media, brightness, special workspaces |
| `50-window_rules.lua` | Window rules |
| `lib/variables.lua` | Shared values: `require("user.lib.variables")` |
| `scripts/`, `hypridle.conf`, `hyprlock.conf` | Helper scripts and the idle/lock daemons' configs. `~/.config/hypr/hypridle.conf` and `~/.config/hypr/hyprlock.conf` are symlinks to these. |

How the loading works:
- Every `user/*.lua` file is loaded in name order through `require("user.<name>")`, so a file name can't contain dots besides `.lua`.
- Hyprland reloads when any of them changes.
- `lib/` isn't loaded by itself; files `require` from it.
- `hl.unbind("KEY")` frees one of axiom's keys.

## Setup

```bash
mkdir -p ~/.config/hypr
ln -s ~/repos/dotfiles/hypr/user ~/.config/hypr/user
ln -s user/hypridle.conf ~/.config/hypr/hypridle.conf
ln -s user/hyprlock.conf ~/.config/hypr/hyprlock.conf
```

Then set axiom's Hyprland mode to Managed (Settings → Desktop → Hyprland).

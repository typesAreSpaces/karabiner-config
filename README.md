# Karabiner configuration

`karabiner.json` contains the active **Default** profile. Karabiner reloads it
automatically when it changes. The **Nothing** profile provides a way to disable
these remappings.

## Shortcuts

Launcher shortcuts use **Control+Option+Command** (either side of each modifier):

| Key | Action |
| --- | --- |
| E | Open a frame on the `jose` Emacs server |
| D | Open a frame on the `doom` Emacs server |
| T | Open a new WezTerm process |
| R | Open WezTerm and attach to an existing tmux session |

The old Command+Shift launcher bindings and duplicate bracket bindings were
removed so applications can receive their usual shortcuts, including Command+Shift+T.

| Shortcut | Action |
| --- | --- |
| Tap Caps Lock | Escape and exit navigation mode |
| Hold Caps Lock with another key | Control |
| Control+semicolon | Backspace |
| Command+5 | Command+Tab |
| Control+G in Sioyek | Escape |
| Double-tap left Option | Toggle navigation mode in supported apps |
| Escape | Exit navigation mode, while still sending Escape |

Navigation mode applies in Safari, Firefox, Chrome, Preview, Finder, and Skim.
It shows a persistent notification while enabled. H/J/K/L send arrow keys;
Shift and Option are preserved for selection and word movement. G sends Home
and Shift+G sends End. Command shortcuts retain their usual behavior.

The mode remains enabled when switching apps and also affects text fields in
supported apps. Press Escape or tap Caps Lock before typing text; Karabiner's
application conditions do not distinguish text fields from other app content.

Mouse zoom applies only in those same apps and only to the configured Logitech
devices (`1133:45085` and `1133:49283`). Button 5 zooms in and button 4 zooms out.
Control+Option+left/right click also zooms in/out; ordinary Control-click remains
available for context menus.

## Dependencies and devices

Launchers expect Apple Silicon Homebrew commands in `/opt/homebrew/bin`:
`emacs`, `emacsclient`, `wezterm`, and `tmux`.

`bin/open-emacs.sh` first connects without waiting for the frame to close. If the
server is unavailable, it starts the matching named daemon and connects again:

| Server | Init directory | Additional environment |
| --- | --- | --- |
| `jose` | `~/.config/jose-emacs` | — |
| `doom` | `~/.config/emacs` | `DOOMDIR=~/.config/doom` |

The script is invoked through `/bin/sh` and supplies a Homebrew-aware PATH.
The tmux launcher requires an existing session.

Device identifiers use decimal `vendor_id:product_id` values. The keyboard entry
`10730:258` now uses the global Caps Lock tap/hold rule. Existing device-specific
Command/Option swaps and function-key settings are retained. Use Karabiner
EventViewer to identify other device entries before removing or changing them.

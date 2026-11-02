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

## Why the shortcuts changed

The shortcuts changed primarily to restore normal application shortcuts, fix
overlapping rules, and make navigation mode predictable. The main change is
commit `87db2ac`, dated **November 2, 2026**, titled “Fix keyboard remapping
conflicts and Emacs launchers.”

This report compares that commit with the preceding configuration. These are
configuration-level findings; the behavior was not reproduced on a keyboard
during the review.

| Shortcut or feature | Previous behavior | Current behavior | Reason for the change |
| --- | --- | --- | --- |
| Emacs launchers | Command+Shift+E / D | Control+Option+Command+E / D | The old global mappings intercepted those combinations before applications could use them. |
| WezTerm launchers | Command+Shift+T / R, plus Command+Shift+bracket alternatives | Control+Option+Command+T / R | Frees application shortcuts and removes redundant launcher bindings. |
| Mouse zoom | Control+left/right click | Control+Option+left/right click | The old left-click mapping consumed Control-click, interfering with context menus. |
| Mouse side buttons | Buttons 4/5 mapped globally to zoom | Zoom only on the two configured Logitech devices in supported apps | Preserves normal button behavior outside the intended devices and apps. |
| Caps Lock | Global tap Escape/hold Control, plus a device-specific Caps-to-Escape mapping | One global tap/hold rule | The device-specific simple mapping could prevent the complex tap/hold rule from receiving Caps Lock. |
| Navigation mode | Double Option toggled it; no visible status or Escape exit | Notification while enabled; Escape or tapped Caps exits | Prevents navigation from remaining active unnoticed and turning typed letters into movement. |
| Shift/Option+HJKL | Did not match the arrow rules | Modified arrow movement | Supports selection and word movement with the navigation keys. |
| Modifier side | Several mappings required left-side modifiers | Either side accepted | Fixes shortcuts working with one modifier key but not its counterpart. |

### Application shortcut conflicts

The launcher conflict was especially concrete: Command+Shift+T launched a
terminal instead of reaching the browser, where it normally reopens closed tabs.
Moving launchers to Control+Option+Command reduces that overlap. Removing the
Command+Shift+bracket mappings also releases those combinations for applications.
See the [launcher configuration](karabiner.json) and
[Chrome's shortcut documentation](https://support.google.com/chrome/answer/157179?hl=en).

### Caps Lock rule overlap

The Caps Lock problem came from two rules operating at different stages. For
keyboard `10730:258`, the simple Caps-to-Escape mapping ran before complex
modifications, so the tap/hold rule could receive Escape instead of Caps Lock.
Removing that simple mapping lets the global rule handle both actions
consistently. This follows Karabiner's documented
[modification order](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-evaluation-priority/).

### Navigation mode behavior

Previously, Escape did not clear the navigation variable. Navigation could stay
enabled while typing in a text field or after switching between supported apps.
The updated rules add a persistent notification and explicitly clear the mode
when Escape or tapped Caps Lock is pressed.

Shift or Option also prevented the earlier plain HJKL rules from matching.
Those modifiers are now explicitly allowed and preserved. Command combinations
remain excluded from the arrow mappings. See Karabiner's
[modifier matching rules](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/from/modifiers/).

### Launcher reliability fixes

Some changes addressed launcher reliability separately from shortcut conflicts.
The [Emacs helper](bin/open-emacs.sh) connects to the requested named server and,
if unavailable, starts that server with its matching configuration. The earlier
`-a emacs` fallback did not explicitly select the matching configuration.

The Alacritty-to-WezTerm replacement happened earlier, in commit `6978131` on
**September 23, 2026**. The November change moved the launcher shortcuts and
updated the tmux launcher to use an explicit `wezterm start` command.

### Remaining overlaps

- Command+5 still becomes Command+Tab globally, so applications cannot receive
  their usual Command+5 action.
- Navigation mode still affects text fields in supported apps and persists
  across app switches. Escape or tapped Caps Lock clears it.

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

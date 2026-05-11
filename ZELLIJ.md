---
name: Zellij Recommendations
description: Unused Zellij features and config optimizations identified for grabowskip's nixos-config setup
type: project
originSessionId: 800e228c-68ab-4d89-a6a6-0e09c7a559ac
---
## High value — not using at all

**zjstatus plugin (community)**
Replaces built-in `status-bar` with fully configurable bar: git branch, datetime, mode indicator, session name.
Install via `load_plugins` or Nix. GitHub: `dj95/zjstatus`

**Session resurrection with viewport serialization**
`serialize_pane_viewport` defaults false — enable to preserve pane scrollback across detach/resurrect:
```kdl
serialize_pane_viewport true
scroll_buffer_size 50000
```
Pair with `post_command_discovery_hook` if using nix shells that obscure the real command.

**Singleton session auto-attach**
Add to config so bare `zellij` always re-attaches to the main session:
```kdl
session_name "main"
attach_to_session true
```

**Clipboard integration for Wayland**
No `copy_command` set; OSC 52 unreliable on some terminals:
```kdl
copy_command "wl-copy"
```

## Medium value — using partially

**compact-bar in layouts**
`compact-bar` alias defined but `default.kdl` uses `status-bar`. Saves a full row; fits locked-mode workflow better.

**show_release_notes false**
Commented out, defaults true. Add next to existing `show_startup_tips false`.

**close_on_exit true in layout panes**
Panes like `lazygit`, `docker-compose`, `npm-start` stay open showing "Command exited" without this:
```kdl
pane command="lazygit" {
    close_on_exit true
}
```

**start_suspended true in layouts**
For panes you don't always need immediately (`just-watch`, `make-test`) — pane exists, command hasn't started yet.

## Lower value — small tweaks

- `scroll_buffer_size 50000` — default 10000 is low for long build output
- `pane_frames false` — more content space; already toggle-able with `z` in pane mode
- `auto_layout false` — prevent Zellij forcing new panes into layout template structure

## Features already configured but underused

- **Swap layouts** (`Ctrl+[` / `Ctrl+]`) — cycles panes through grid/horizontal/vertical tiling without closing anything
- **EditScrollback** (`e` in scroll mode) — opens full scrollback in `$EDITOR`; great for grepping build output
- **Pane groups** (`Alt p` / `Alt Shift p`) — mark panes into a group, resize/move together (added in 0.40+)
- **`zellij action` CLI** — script Zellij from inside panes: `zellij action new-pane`, `zellij action focus-next-pane`

## Files reviewed
- `modules/home-manager/programs/zellij/config.kdl` (516 lines)
- `modules/home-manager/programs/zellij/layouts/default.kdl`
- `home/work/iqvia-mbp/zellij-layout.kdl`
- `home/patrykgrabowski/dmuchawa/zellij-layout.kdl`

https://github.com/karimould/zellij-forgot

 After nh home switch:
     1. Start a new zellij session — verify compact-bar renders (single-row, no mode text)
     2. zellij → should auto-attach to "main" session
     3. Open a pane with a command, let it exit — should close automatically (for lazygit pane)
     4. Scroll up in a pane, detach, re-attach — scrollback should persist (serialize_pane_viewport)
     5. Check pane frames are gone by default (toggled with z in pane mode if needed)

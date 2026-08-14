# Progress log

Newest entries on top. Timestamps in `YYYY-MM-DD` local (Europe/Warsaw).

## 2026-08-14 — dmuchawa upgraded to 26.05

- `darwin-rebuild switch --flake .#dmuchawa` succeeded. Running `darwin-system-26.05.c3e90c8` (generation 11, activated 17:59 local).
- Applied edits: flake.nix inputs bumped (nixpkgs, nixpkgs-stable, nix-darwin, home-manager, catppuccin) to 26.05; `modules/home-manager/programs/nvim.nix` `extraLuaConfig` → `initLua`.
- Homebrew snag encountered: nix-darwin 26.05 passes `--force-cleanup` to `brew bundle`, rejected by older Homebrew with `Error: invalid option: --force-cleanup`. Fix: `brew update` to >= 5.1.15. Captured in `CHECKLIST-iqvia-mbp.md` pre-flight.
- Remaining non-blocking eval warnings on dmuchawa:
  - `nvim-treesitter-legacy is deprecated, please migrate to the new version. This will become an error in 26.11`
  - `programs.neovim.withRuby` default flipped `true → false`; legacy `true` still applied because `home.stateVersion < 26.05` (kept intentionally).
- Rollback path: `sudo darwin-rebuild rollback` returns to generation 10 (`darwin-system-25.11.ebec37a`).

## 2026-08-14 — research phase complete

All six research streams finished. Findings in `RESEARCH.md`. Per-host checklists written. No nix files edited yet.

### Headline findings

- **nix-darwin**: zero code changes for our config. Just bump flake input.
- **catppuccin**: zero code changes. Just bump flake input.
- **home-manager**: two real edits — nvim `extraLuaConfig → initLua`, hyprland pin `configType = "hyprlang"`. Two optional pins (yazi, zsh).
- **NixOS core**: one real edit — wine `wineWowPackages → wineWow64Packages`. Kernel/bootloader modernization optional but recommended (drop pinned `linuxPackages_6_18`; add `boot.initrd.systemd.enable = true` before 26.11).
- **Third-party**: hyprpanel is a landmine. Upstream flake archived 2026-04-27. And our flake.nix does not declare a HyprPanel input despite using `programs.hyprpanel` — resolve before the switch on koksownik.
- **stateVersion**: friend bumped his (both system and home) to 26.05 — this is the wrong idiom. Leave ours at 25.11.

### Friend's migration reference

Commits `bd4d963 → fc15a45 → 19314d0 → b1ebeb1` in `../grzesieks-nixos-config`. Extract signals in `RESEARCH.md §6`.

### Additional discovery — Hyprland Lua schema

Friend commit `42d302b` (2026-06-16 "rewritten hyprland.nix to be 100% lua") rewrote hyprland module from `settings` attrset to `extraConfig` Lua block. Driven by HM 26.05 flipping `configType` default `hyprlang → lua`. Two migration paths documented in `RESEARCH.md §6` and `CHECKLIST-koksownik.md`:

- **Option A** (recommended for upgrade): pin `configType = "hyprlang";` — minimal diff.
- **Option B** (friend's path): full Lua rewrite via `hl.config/env/animation/bind/monitor/curve` — post-upgrade PR.

## 2026-08-14 — research phase started

- Confirmed target NixOS 26.05 (user first said 26.11 which does not exist yet; nixos-26.05 branch is current stable).
- Created `upgrade/` docs. Spawned 6 parallel research agents:
  1. NixOS 26.05 core release notes
  2. nix-darwin 26.05
  3. home-manager release-26.05
  4. catppuccin release-26.05
  5. Third-party inputs (sops-nix, nix-flatpak, nix-citizen, hyprland ecosystem, nixos-hardware)
  6. Diff friend's already-migrated fork
- Current flake inputs (pre-upgrade) captured in git at HEAD.
- No file edits to any nix module yet. Safe to abort.

## Handoff checkpoints

- [x] Research complete → RESEARCH.md populated
- [x] Checklists written
- [x] dmuchawa upgraded and stable (gen 11, 2026-08-14)
- [ ] iqvia-mbp upgraded and stable
- [ ] koksownik upgraded and stable

## Notes for the next agent

- If you take over on koksownik: read RESEARCH.md then CHECKLIST-koksownik.md. Cross-reference actual current state in flake.lock — user may have made partial edits.
- Always `nix flake check` and `nixos-rebuild build --flake .#koksownik` before ever running `switch`.
- Friend's fork = `/Users/patrykgrabowski/grzesieks-nixos-config` — grep there when uncertain how an option should look post-upgrade.

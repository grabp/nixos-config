# Checklist — dmuchawa (personal MacBook, nix-darwin)

Do first. Very small surface — nix-darwin has zero known code changes for our config.

## Pre-flight

- [ ] Clean working tree: `git status` in `/Users/patrykgrabowski/nixos-config`.
- [ ] Baseline builds green on current inputs: `darwin-rebuild build --flake .#dmuchawa`.
- [ ] Note current generation: `darwin-rebuild --list-generations | tail`.

## Flake input bumps

Edit `flake.nix`:

- [ ] `nixpkgs.url` → `github:nixos/nixpkgs/nixos-26.05`
- [ ] `nixpkgs-stable.url` → `github:nixos/nixpkgs/nixos-26.05`
- [ ] `nix-darwin.url` → `github:nix-darwin/nix-darwin/nix-darwin-26.05`
- [ ] `home-manager.url` → `github:nix-community/home-manager/release-26.05`
- [ ] `catppuccin.url` → `github:catppuccin/nix/release-26.05`

Then:

- [ ] `nix flake update` (regenerates `flake.lock` for all inputs, including hardware, sops-nix, nix-flatpak, nix-citizen).

## Home-manager module edits (needed for both hosts)

- [ ] `modules/home-manager/programs/nvim.nix`: `extraLuaConfig` → `initLua`.
- [ ] `modules/home-manager/desktop/hyprland.nix`: add `configType = "hyprlang";` (only used on koksownik path, but doesn't hurt if imported). Confirm dmuchawa doesn't import the desktop set.
- [ ] Optional: `modules/home-manager/programs/yazi.nix` pin `shellWrapperName = "yy";`.
- [ ] Optional: `modules/home-manager/programs/zsh.nix` pin `dotDir = "~";` (else `~/.zshrc` becomes stale on next `home.stateVersion` bump).

## Verify

- [ ] `darwin-rebuild build --flake .#dmuchawa` — succeeds.
- [ ] `darwin-rebuild switch --flake .#dmuchawa` — applies.
- [ ] Smoke test: shell prompt, nvim starts, kitty theme, gpg-agent, YubiKey PIN prompt, 1Password, homebrew brews still active.
- [ ] Log outcome to `PROGRESS.md`.

## Do NOT change

- `system.stateVersion = 6` — keep.
- `home.stateVersion` — keep at current value.
- Any homebrew module option — 26.05 unchanged for our surface.

## Rollback

- `sudo darwin-rebuild rollback` reverts to previous generation.

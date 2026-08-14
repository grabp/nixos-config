# Research findings — NixOS 25.11 → 26.05

_All items below are concrete. Skip generic advice. Refresh individual agent runs if any item goes stale._

---

## 1. NixOS 26.05 core

Source: https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-26.05/nixos/doc/manual/release-notes/rl-2605.section.md

### Actionable changes

| File | Line | Change | Reason |
|---|---|---|---|
| `modules/nixos/programs/wine.nix` | 7, 13 | `wineWowPackages.stable` → `wineWow64Packages.stable`; `wineWowPackages.waylandFull` → `wineWow64Packages.waylandFull` | `wineWowPackages` deprecated for Wine ≥ 11.0 |
| `modules/nixos/common/bootloader.nix` | 22 | `pkgs.linuxPackages_6_18` → `pkgs.linuxPackages` (or drop line) | 6.18 is default kernel now; redundant |
| `modules/nixos/common/bootloader.nix` | — | add `boot.initrd.systemd.enable = true;` | Scripted initrd deprecated, removal in 26.11. Verify LUKS naming in `hosts/koksownik/default.nix:22` still resolves under systemd initrd |
| `modules/nixos/common/packages.nix` | end | add `nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];` | Friend hit this — likely electron pulled by obs-studio/thunderbird. Confirm via build error before adding. |

### Notable non-changes

- `services.pulseaudio.enable = false;` — still correct.
- `services.xserver.videoDrivers = [ "amdgpu" ]` — still valid.
- `services.avahi.wideArea` default flipped `true → false` (CVE-2024-52615). Re-enable only if unicast DNS-SD needed.
- `services.openssh.settings.Banner` (renamed) — not used.
- `services.pipewire`, `security.rtkit`, `programs.hyprland`, `programs.steam`, `programs.firefox`, `programs._1password{,-gui}`, `hardware.bluetooth`, `hardware.amdgpu.*`, `services.hardware.openrgb`, `services.lact`, `services.ollama`, `services.open-webui`, `services.wivrn` — all unchanged.
- **Do NOT bump `system.stateVersion`.** Friend bumped his to `26.05` but that's the wrong idiom — stateVersion pins first-install release and is intentional. Leave `25.11` (and koksownik's actual first-install value).

### Package renames hitting closure

- `wineWowPackages.*` → `wineWow64Packages.*` (only real hit).
- `mysql80` removed — not used.
- `rocmPackages_6` removed; ROCm 7.x may break `pkgs.ollama-rocm` on koksownik. If build fails, pin from `nixpkgs-unstable` or override.

---

## 2. nix-darwin 26.05

Source: https://github.com/nix-darwin/nix-darwin/releases

### Actionable changes

**None.** Full darwin surface is unchanged in 26.05:

- `system.stateVersion = 6` — keep. (`= 7` would flip tmux split bindings, but we don't set `programs.tmux.enableSensible`.)
- `security.pam.services.sudo_local.touchIdAuth` — unchanged.
- `system.primaryUser` — unchanged, still required.
- `nix.settings`, `nix.optimise.automatic`, `nix.package` — unchanged.
- `users.users.<name>.{name,home}` — unchanged.
- `homebrew.{enable,onActivation.*,brews,casks}` — unchanged.
- `fonts.packages` — unchanged.

### Optional / cosmetic

- New `homebrew.cleanup = "check"` mode (dry-run) — alternative to `"uninstall"` in `modules/darwin/common/homebrew.nix:8`.
- New `homebrew.enableZshIntegration` — optional convenience.
- `homebrew.brewPrefix` → `homebrew.prefix` — not used.
- `homebrew.whalebrews`, `homebrew.global.lockfiles`, `homebrew.global.noLock` removed — not used.

---

## 3. home-manager release-26.05

Source: https://nix-community.github.io/home-manager/release-notes.xhtml

### Actionable changes

| File | Line | Change | Reason |
|---|---|---|---|
| `modules/home-manager/programs/nvim.nix` | ~58 | `extraLuaConfig = …` → `initLua = …` | Renamed |
| `modules/home-manager/desktop/hyprland.nix` | ~5 | Add `configType = "hyprlang";` under `wayland.windowManager.hyprland` | Default flipped `hyprlang → lua`; our config is attrset-based hyprlang. Also need `configType` pin on any per-host consumer of `wayland.windowManager.hyprland.settings.*` (e.g. `home/grabowskip/koksownik/default.nix` monitor block). See §6 friend note — he took Option B (full Lua rewrite). |
| `modules/home-manager/programs/yazi.nix` | — | Optional: pin `shellWrapperName = "yy";` | Default changed `yy → y`; preserve muscle memory if desired |
| `modules/home-manager/programs/zsh.nix` | — | Optional: pin `dotDir = "~";` | Default moves `.zshrc` to `~/.config/zsh/.zshrc` |
| `modules/home-manager/programs/nvim.nix` | — | Optional: set `withPython3` / `withRuby` explicitly | Defaults flipped to `false`; add only if a LazyVim plugin needs them |

### Non-changes verified

- `programs.git.settings` — already correct (RFC 42 style).
- `wireplumber` config path via `xdg.configFile` — unaffected.
- `services.mako`, `programs.fuzzel`, `services.hyprpaper`, `programs.hyprlock`, `services.hypridle`, `programs.waybar`, `programs.obs-studio`, `services.gpg-agent`, `programs.kitty`, `programs.bat`, `programs.btop`, `programs.direnv`, `programs.eza`, `programs.fastfetch`, `programs.fzf`, `programs.jq`, `programs.lazygit`, `programs.ripgrep`, `programs.zoxide`, `programs.helix`, `programs.tmux` — no relevant renames.

### `home.stateVersion`

Same rule as system stateVersion. Do NOT bump on upgrade. Friend bumped his — wrong idiom.

---

## 4. catppuccin release-26.05

Source: https://github.com/catppuccin/nix/tree/release-26.05

### Actionable changes

**None.** `release-26.05` exists (tag `v26.05`, 2026-05-25). Only 26.05 breaking changes were:

- Removed legacy `mkRenamedCatppuccinOptions` aliases (e.g. old `programs.fzf.catppuccin.enable`) — we already use modern paths (`catppuccin.fzf.enable` etc.).
- `catppuccin.fish` fix — we don't use fish.

All our usage stays valid:

- `catppuccin.homeModules.catppuccin` — attr still exists.
- `catppuccin.nixosModules.catppuccin` — attr still exists.
- `catppuccin.{enable,flavor,accent,cache.enable,nvim.enable}` — unchanged.
- `catppuccin.fzf`, `catppuccin.kitty` — modern paths already, no rename.

### Optional new modules (not required)

`opencode`, `broot`, `gemini-cli`, `hyprtoolkit`, `qt5ct`, `wleave`, waybar `@accent` variable.

---

## 5. Third-party flake inputs

| Input | Action | Reason |
|---|---|---|
| `nixpkgs`, `nixpkgs-stable` | **bump** to `nixos-26.05` | main driver |
| `nix-darwin` | **bump** to `nix-darwin-26.05` | matches nixpkgs release |
| `home-manager` | **bump** to `release-26.05` | matches nixpkgs release |
| `catppuccin` | **bump** to `release-26.05` | matches nixpkgs release |
| `hardware` (nixos-hardware) | no ref change; `nix flake update hardware` | no release branches |
| `sops-nix` | no ref change; `nix flake update sops-nix` | follows our `nixpkgs` |
| `nix-flatpak` | no ref change; consider pinning to `v0.7.0` tag | main branch can break per README |
| `nix-citizen` | no ref change; `nix flake update nix-citizen` | tracks unstable; no recent breaking commits |

### Special concern — `programs.hyprpanel`

- Referenced in `modules/home-manager/desktop/hyprpanel.nix` but **no HyprPanel flake input is declared in `flake.nix`**. Current eval must be broken already, OR the option is provided via another path we missed.
- Upstream `github:Jas-SinghFSU/HyprPanel` was **archived 2026-04-27**. Successor is `github:wayle-rs/wayle`.
- Action: verify current eval state on koksownik pre-upgrade. If it works today, decide whether to add HyprPanel flake input explicitly (frozen upstream) or migrate to Wayle. Do this **before** the 26.05 switch to keep the diff clean.

---

## 6. Friend's migration commits (`../grzesieks-nixos-config`)

Commit chain that migrated 25.11 → 26.05:

| SHA | Date | Change |
|---|---|---|
| `bd4d963` | 2026-06-14 | Bump `flake.nix` inputs to 26.05 (nixpkgs, nix-darwin, home-manager, catppuccin) |
| `fc15a45` | 2026-06-14 | Bumped `system.stateVersion "25.11" → "26.05"` — **do NOT copy**; wrong idiom |
| `19314d0` | 2026-06-14 | `flake.lock` regen; fix flake input path typo; added `permittedInsecurePackages = [ "electron-39.8.10" ]` in `modules/nixos/common/packages.nix` |
| `b1ebeb1` | 2026-06-15 | Bumped `home.stateVersion`s (don't copy). Removed `services.ollama.acceleration = "rocm"` (kept `package = pkgs.ollama-rocm`). Removed `programs.adb.enable = true`. |

### Signals extracted

- `permittedInsecurePackages = [ "electron-39.8.10" ]` — add if we hit an electron eval error (probably obs-studio or thunderbird).
- `services.ollama.acceleration` — friend removed the option. Verify: is `acceleration` deprecated/removed in 26.05? If yes, drop from `hosts/koksownik/default.nix`. If it's still valid, leave. Check search.nixos.org during upgrade.
- `programs.adb.enable = true` removal — friend's personal preference (mobile dev not needed anymore), not a rename. Do NOT copy — we may still want it on koksownik.
- Friend did not touch home-manager module bodies for HM 26.05 renames (nvim). Either they're relying on lax evaluation or they don't use those exact options; we should still apply the HM section changes above.
- **Hyprland Lua rewrite (`42d302b` 2026-06-16)**: friend rewrote `modules/home-manager/desktop/hyprland.nix` from `settings = {...}` attrset → `extraConfig = ''hl.config({...}) hl.env(...) hl.animation(...) hl.bind(...) hl.monitor(...)''` Lua block. Also flipped `home/adriwin/desktop/default.nix` monitor from `wayland.windowManager.hyprland.settings.monitor = [ ... ]` to `extraConfig = ''hl.monitor({ ... })''`. Kept old file as `hyprland.nix.backup`. Motivation: HM 26.05 flipped `configType` default `hyprlang → lua`, so friend embraced Lua rather than pin. This is **Option B** in the checklist. Two migration paths:
  - **Option A (recommended, minimal diff)**: pin `configType = "hyprlang";` on `wayland.windowManager.hyprland` in `modules/home-manager/desktop/hyprland.nix`, keep all `settings.*` attrset code. Also pin on per-host files that set `settings.monitor` (`home/grabowskip/koksownik/default.nix` — currently uses `settings.monitor = [...]`).
  - **Option B (align with new default)**: rewrite our hyprland into `extraConfig` Lua using `hl.config`, `hl.env`, `hl.animation`, `hl.bind`, `hl.monitor`, `hl.curve`. Big diff. Do post-upgrade as a separate PR.

### Other post-upgrade friend commits worth tracking

- `8f938b7` "possible fix for Hyprland": added `services.seatd.enable = true;` in `modules/nixos/common/default.nix` (GPU/session handover). If Hyprland fails to start on koksownik post-upgrade, mirror this. Also moved `~/.p10k.zsh` sourcing from init-early block into `programs.zsh.initExtra` — likely because HM 26.05 `dotDir` behavior shifts where `initContent` lands. Watch our zsh module if we ever bump `home.stateVersion`.
- `aaf178f` (2026-04-23, pre-upgrade, authored by user grabowskip): `pinentry-curses` → `pinentry-qt` in `modules/home-manager/programs/gpg.nix`. **Already applied in our repo** (verified `pinentry-qt` at line 9 and 28-29). No action.
- `1b52b85`, `7f8e904`, `e005b66`, `7b60917`: bugfixes in friend's Lua Hyprland rewrite. Reference only if we take Option B.
- `285fc7a`, `74a87a5`: feature adds (easyeffects, p10k prompt migration). Not schema-driven. Skip.

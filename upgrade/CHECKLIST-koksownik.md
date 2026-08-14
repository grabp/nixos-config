# Checklist — koksownik (NixOS desktop, AMD, Hyprland, gaming, VR)

Do **last**. Largest surface. Expect issues around hyprpanel, ollama-rocm, wine.

## Pre-flight

- [ ] Confirm flake.lock already bumped by dmuchawa's PR/merge. If not, do the flake edits from `CHECKLIST-dmuchawa.md` first.
- [ ] Baseline builds: `sudo nixos-rebuild build --flake .#koksownik` on **current** 25.11 to confirm start-state is green.
- [ ] Note bootloader generation count: `sudo nix-env -p /nix/var/nix/profiles/system --list-generations | tail -5`.
- [ ] Snapshot important state (`/etc/nixos` if you have overrides, home files not tracked by HM).

## Pre-upgrade fixups (do on 25.11 first if possible)

- [ ] **hyprpanel resolution.** Grep confirms `programs.hyprpanel` is used but no HyprPanel flake input is declared. Either:
   - Add explicit input: `hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";` and wire its home-manager module in `lib/mksystem.nix` alongside `catppuccin.homeModules.catppuccin`.
   - Or migrate to `github:wayle-rs/wayle`.
   - Or temporarily comment out import of `modules/home-manager/desktop/hyprpanel.nix` to unblock the upgrade.
- [ ] Verify current eval succeeds. If it does, hyprpanel is coming from somewhere (nixpkgs? overlay?) — grep once more.

## Nix code edits

- [ ] `flake.nix` — already bumped by dmuchawa phase.
- [ ] `modules/nixos/programs/wine.nix`:
   - `wineWowPackages.stable` → `wineWow64Packages.stable`
   - `wineWowPackages.waylandFull` → `wineWow64Packages.waylandFull`
- [ ] `modules/nixos/common/bootloader.nix`:
   - Simplify `pkgs.linuxPackages_6_18` → `pkgs.linuxPackages` (or drop the line — 6.18 is default in 26.05).
   - Add `boot.initrd.systemd.enable = true;` (deprecation of scripted initrd; must be done before 26.11). Verify LUKS device naming still resolves under systemd initrd (`hosts/koksownik/default.nix:22`).
- [ ] Home-manager edits (applies system-wide; already done in dmuchawa phase):
   - `modules/home-manager/programs/nvim.nix`: `extraLuaConfig` → `initLua`.
   - `modules/home-manager/desktop/hyprland.nix`: add `configType = "hyprlang";` under `wayland.windowManager.hyprland`.
   - `home/grabowskip/koksownik/default.nix`: same pin needed since it sets `wayland.windowManager.hyprland.settings.monitor`. Add `wayland.windowManager.hyprland.configType = "hyprlang";` alongside the monitor line (or accept the module-level pin covers it — HM merges submodule scopes, so one pin should suffice; verify at build time).
   - **Optional post-upgrade rewrite (Option B)**: mimic friend `42d302b` and convert to `extraConfig` Lua (`hl.config`, `hl.env`, `hl.animation`, `hl.bind`, `hl.monitor`, `hl.curve`). Do as separate PR after 26.05 is stable.

## Build → fix loop

- [ ] `sudo nixos-rebuild build --flake .#koksownik`. Read every warning.
- [ ] Common failure fixes (apply only if triggered):
   - Electron eval error → add to `modules/nixos/common/packages.nix`:
     ```nix
     nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
     ```
     (bump version to match the error string).
   - `services.ollama.acceleration = "rocm"` errors → drop that line (friend removed his; verify against search.nixos.org).
   - `ollama-rocm` fails to build under ROCm 7 → temporarily pin `services.ollama.package = pkgs-unstable.ollama-rocm;` via overlay or disable ollama on this rebuild.
   - `wivrn` service option changes → check search.nixos.org.
   - `nix-citizen` closure conflict → set `inputs.nix-citizen.inputs.nixpkgs.follows = "nixpkgs-unstable";` if not already; accept duplicate closure.
   - Hyprland fails to start / login → mirror friend's `8f938b7`: add `services.seatd.enable = true;` to `modules/nixos/common/default.nix`. Seatd handles compositor session/GPU handover under stricter 26.05 defaults.
   - zsh `~/.p10k.zsh` no longer sourced → check the position of the `[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh` line in `modules/home-manager/programs/zsh.nix`. Friend moved it into `programs.zsh.initExtra` in `8f938b7` because HM 26.05 changed where `initContent` (or predecessor block) lands relative to $XDG_CONFIG_HOME dotDir.

## Switch

- [ ] `sudo nixos-rebuild switch --flake .#koksownik`.
- [ ] If boot-critical fails, reboot to previous generation from systemd-boot menu.

## Smoke tests

- [ ] Login via SDDM.
- [ ] Hyprland starts, waybar renders, mako toasts, hyprpanel launches, kitty theme applied.
- [ ] Audio: pipewire, wireplumber, bluetooth pair.
- [ ] YubiKey unlock via gpg-agent + pcscd.
- [ ] 1Password GUI.
- [ ] Flatpak apps still installed (`flatpak list`).
- [ ] Steam launches; wine game works (wine64 path).
- [ ] Star Citizen (nix-citizen) launches.
- [ ] VR (wivrn) starts.
- [ ] AMD GPU: `radeontop` / `nvtop` shows usage.
- [ ] Ollama serves; open-webui responds.
- [ ] Samba shares mount (`/mnt/share/*`).
- [ ] Log outcome to `PROGRESS.md`.

## Do NOT change

- `system.stateVersion` — keep whatever it was at first install of this box.
- `home.stateVersion` in `home/grabowskip/koksownik/default.nix` — keep.

## Rollback

- Boot previous generation from systemd-boot menu.
- Or once booted on new gen: `sudo nixos-rebuild switch --rollback`.

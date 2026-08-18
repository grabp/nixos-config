# NixOS 25.11 → 26.05 Upgrade Plan

Target confirmed: **NixOS 26.05** (stable). Friend's fork already migrated — reference `../grzesieks-nixos-config`.

## Rollout order

1. **dmuchawa** (personal MacBook) — nix-darwin
2. **iqvia-mbp** (work MacBook) — nix-darwin, do only after dmuchawa stable
3. **koksownik** (NixOS desktop) — biggest surface, expect the most breakage

## High-level steps per host

1. Snapshot: `nixos-rebuild build` or `darwin-rebuild build` on current pinned inputs to confirm green baseline.
2. Update flake inputs:
   - `nixpkgs`, `nixpkgs-stable` → `github:nixos/nixpkgs/nixos-26.05`
   - `nix-darwin` → `github:nix-darwin/nix-darwin/nix-darwin-26.05`
   - `home-manager` → `github:nix-community/home-manager/release-26.05`
   - `catppuccin` → `github:catppuccin/nix/release-26.05`
   - `nixpkgs-unstable` stays on `nixos-unstable`
   - Other inputs: see RESEARCH.md decisions.
3. `nix flake update` (or targeted `nix flake lock --update-input <name>`).
4. Try build; fix option renames iteratively.
5. Test in a shell / boot; if desktop rebuild — do `switch` last.
6. Commit per host with clear message.

## Safety rails

- Always `build` before `switch`. Rollback path: previous generation.
- On darwin: `sudo darwin-rebuild rollback` if `switch` breaks.
- On koksownik: keep old generation in bootloader; select at boot if needed.
- Keep `home-manager.backupFileExtension = "backup"` (already set) so HM won't clobber.

## Files & tracking

- `RESEARCH.md` — raw findings per source (release notes, nix-darwin, HM, catppuccin, third-party, friend diff).
- `CHECKLIST-dmuchawa.md` — actionable list, tick as done.
- `CHECKLIST-koksownik.md` — actionable list, tick as done.
- `PROGRESS.md` — running log; koksownik agent reads this to resume.

## Handoff note for koksownik agent

Read `PROGRESS.md` last-entry first. That reveals which host finished and any surprises hit on dmuchawa that may repeat on koksownik.

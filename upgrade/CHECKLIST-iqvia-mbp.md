# Checklist — iqvia-mbp (work MacBook, nix-darwin)

Do **after** dmuchawa is stable. Same code path — should be a no-op after the shared flake.lock bump if dmuchawa succeeded.

## Pre-flight

- [ ] Pull the branch used on dmuchawa (should be `main`).
- [ ] **Update Homebrew to >= 5.1.15 before switch**: `brew update && brew --version`. nix-darwin 26.05 passes `--force-cleanup` to `brew bundle`, which older Homebrew rejects with `Error: invalid option: --force-cleanup`. Hit on dmuchawa during 26.05 rollout. Refs: nix-darwin#1787, Homebrew/brew#22453. Escape hatch if update blocked: set `homebrew.onActivation.cleanup = "none"` in `modules/darwin/common/homebrew.nix`.
- [ ] Baseline: `darwin-rebuild build --flake .#iqvia-mbp`.

## Apply

- [ ] `darwin-rebuild switch --flake .#iqvia-mbp`.
- [ ] Smoke test: work git commits sign, 1Password, kitty, gpg-agent, IQVIA-specific homebrew casks.
- [ ] Log outcome to `PROGRESS.md`.

## Rollback

- `sudo darwin-rebuild rollback`.

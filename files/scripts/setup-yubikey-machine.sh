#!/usr/bin/env bash
# setup-yubikey-machine — idempotent bootstrap of Yubikey GPG/SSH on a new machine.
# Safe to run multiple times. Does not write gpg-agent.conf or sshcontrol —
# those are managed by nix home-manager; this script only verifies they exist.
set -uo pipefail

PRIMARY_FP="6C4D33083EDEF83D043C897BD4ADECA93F52036C"
KEYSERVER_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/${PRIMARY_FP}"
RECIPIENT="grabowskip@icloud.com"
AUTH_KEYGRIP="648967E7D2D51663B5F38FDE09AA07CC2CB00A67"

# ---------------------------------------------------------------------------
# Detect OS
# ---------------------------------------------------------------------------
OS=$(uname -s)
case "$OS" in
  Darwin) PLATFORM="macOS" ;;
  Linux)  PLATFORM="Linux" ;;
  *)      PLATFORM="$OS" ;;
esac

echo "=== Yubikey Machine Setup ==="
echo "Platform: $PLATFORM"
echo ""

# ---------------------------------------------------------------------------
# Step 1: Verify required tools
# ---------------------------------------------------------------------------
echo "[1/9] Verifying required tools..."
MISSING=0
for tool in gpg gpg-agent gpgconf; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "  ERROR: '$tool' not found in PATH — should be installed by nix home-manager"
    MISSING=$((MISSING+1))
  else
    echo "  OK: $tool ($(command -v "$tool"))"
  fi
done
if [ "$MISSING" -gt 0 ]; then
  echo "ERROR: $MISSING required tool(s) missing. Run 'home-manager switch' first."
  exit 1
fi

# ---------------------------------------------------------------------------
# Step 2: Ensure ~/.gnupg has correct permissions
# ---------------------------------------------------------------------------
echo ""
echo "[2/9] Ensuring ~/.gnupg permissions..."
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
echo "  OK: ~/.gnupg exists with mode 700"

# ---------------------------------------------------------------------------
# Step 3: Import public key
# ---------------------------------------------------------------------------
echo ""
echo "[3/9] Importing public key ($PRIMARY_FP)..."

# Check if already imported
if gpg --list-keys "$PRIMARY_FP" >/dev/null 2>&1; then
  echo "  OK: Public key already in keyring — skipping import"
else
  echo "  Trying keyserver (keys.openpgp.org)..."
  IMPORTED=0
  gpg --keyserver hkps://keys.openpgp.org --recv-keys "$PRIMARY_FP" 2>/dev/null && IMPORTED=1 || true

  if [ "$IMPORTED" -eq 0 ]; then
    echo "  Keyserver failed — trying direct URL fetch..."
    gpg --fetch-keys "$KEYSERVER_URL" 2>/dev/null && IMPORTED=1 || true
  fi

  if [ "$IMPORTED" -eq 0 ]; then
    echo "  URL fetch failed — trying gpg --card-status to fetch from card..."
    gpg --card-status >/dev/null 2>&1 && IMPORTED=1 || true
  fi

  if gpg --list-keys "$PRIMARY_FP" >/dev/null 2>&1; then
    echo "  OK: Public key imported successfully"
  else
    echo "  WARNING: Could not import public key automatically."
    echo "  Insert the Yubikey and run: gpg --card-status"
    echo "  Or import manually: gpg --recv-keys $PRIMARY_FP"
  fi
fi

# ---------------------------------------------------------------------------
# Step 4: Materialise GPG stubs from card
# ---------------------------------------------------------------------------
echo ""
echo "[4/9] Materialising GPG stubs from card..."
if gpg --card-status >/dev/null 2>&1; then
  echo "  OK: gpg --card-status succeeded (stubs materialised)"
else
  echo "  WARNING: gpg --card-status failed — Yubikey may not be inserted"
  echo "  Insert the Yubikey and re-run this script, or run: gpg --card-status"
fi

# ---------------------------------------------------------------------------
# Step 5: Set ultimate trust on primary key
# ---------------------------------------------------------------------------
echo ""
echo "[5/9] Setting ultimate trust on primary key..."
if echo "${PRIMARY_FP}:6:" | gpg --import-ownertrust 2>/dev/null; then
  echo "  OK: Ultimate trust set for $PRIMARY_FP"
else
  echo "  WARNING: Could not set ultimate trust (key may not be imported yet)"
fi

# ---------------------------------------------------------------------------
# Step 6: Verify gpg-agent.conf
# ---------------------------------------------------------------------------
echo ""
echo "[6/9] Verifying gpg-agent.conf (managed by nix home-manager)..."
GPG_AGENT_CONF="$HOME/.gnupg/gpg-agent.conf"
if [ -f "$GPG_AGENT_CONF" ]; then
  echo "  OK: $GPG_AGENT_CONF exists"
  if grep -q "enable-ssh-support" "$GPG_AGENT_CONF"; then
    echo "  OK: enable-ssh-support is set"
  else
    echo "  WARNING: enable-ssh-support not found in gpg-agent.conf"
    echo "  Run 'home-manager switch' to regenerate nix-managed config files"
  fi
else
  if [ "$PLATFORM" = "Linux" ]; then
    echo "  INFO: gpg-agent.conf not present on Linux (managed by systemd/home-manager — OK)"
  else
    echo "  WARNING: $GPG_AGENT_CONF missing"
    echo "  Run 'home-manager switch' to create nix-managed config files"
  fi
fi

# ---------------------------------------------------------------------------
# Step 7: Verify sshcontrol
# ---------------------------------------------------------------------------
echo ""
echo "[7/9] Verifying sshcontrol..."
SSHCONTROL="$HOME/.gnupg/sshcontrol"
if [ -f "$SSHCONTROL" ]; then
  if grep -q "$AUTH_KEYGRIP" "$SSHCONTROL"; then
    echo "  OK: sshcontrol contains auth keygrip $AUTH_KEYGRIP"
  else
    echo "  WARNING: sshcontrol exists but missing keygrip $AUTH_KEYGRIP"
    echo "  Run 'home-manager switch' to regenerate"
  fi
else
  echo "  WARNING: sshcontrol not found at $SSHCONTROL"
  echo "  Run 'home-manager switch' to create nix-managed config files"
fi

# ---------------------------------------------------------------------------
# Step 8: Restart gpg-agent
# ---------------------------------------------------------------------------
echo ""
echo "[8/9] Restarting gpg-agent..."
gpgconf --kill gpg-agent 2>/dev/null || true
sleep 1
gpgconf --launch gpg-agent 2>/dev/null || true
echo "  OK: gpg-agent restarted"

# Also ensure SSH_AUTH_SOCK is pointing at the right socket
SSH_SOCK=$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null || true)
if [ -n "$SSH_SOCK" ]; then
  echo "  INFO: SSH auth socket: $SSH_SOCK"
  echo "  Add to your shell profile if not already set:"
  echo "    export SSH_AUTH_SOCK=\$(gpgconf --list-dirs agent-ssh-socket)"
fi

# ---------------------------------------------------------------------------
# Step 9: Print SSH public key
# ---------------------------------------------------------------------------
echo ""
echo "[9/9] SSH public key served by agent:"
SSH_KEYS=$(ssh-add -L 2>/dev/null || true)
if [ -n "$SSH_KEYS" ]; then
  echo "$SSH_KEYS"
else
  echo "  (no keys served yet — Yubikey may not be inserted, or stubs not materialised)"
  echo "  Insert Yubikey and run: ssh-add -L"
fi

# ---------------------------------------------------------------------------
# Next steps
# ---------------------------------------------------------------------------
echo ""
echo "=== Next Steps ==="
echo ""
echo "1. Add your SSH public key to GitHub:"
echo "   https://github.com/settings/keys"
echo "   (copy the ssh-ed25519 key printed above)"
echo ""
echo "2. Test SSH authentication:"
echo "   ssh -T git@github.com"
echo "   (should say: Hi <username>! You've successfully authenticated...)"
echo ""
echo "3. Test GPG signing:"
echo "   echo 'test' | gpg --clearsign --local-user $RECIPIENT"
echo ""
echo "4. Verify everything with:"
echo "   verify-yubikey"
echo ""
echo "Done."

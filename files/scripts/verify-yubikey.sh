#!/usr/bin/env bash
# verify-yubikey — run 11 checks against the currently inserted Yubikey.
# Exits 0 only if every check passes.
set -uo pipefail

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
YK1_SERIAL="36316131"
YK2_SERIAL="32483037"

# Current shared subkeys (post Option-A migration, both cards carry these)
SHARED_E_FP="AF9D2ABCA60A863DB21E548A95CBAE324B1AB319"
SHARED_A_FP="F660540384F9621617E94443961414ED7FF5C32B"
AUTH_KEYGRIP="648967E7D2D51663B5F38FDE09AA07CC2CB00A67"
EXPECTED_SSH_PUBKEY="AAAAC3NzaC1lZDI1NTE5AAAAIBfJboJOYiM9gm7iYoSLZZ8FBjH6WcbdRqk0WMTWqBes"
RECIPIENT="grabowskip@icloud.com"

PASS=0
FAIL=0

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
pass() { echo "  [PASS] $1"; PASS=$((PASS+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

sep() { echo ""; echo "--- $1 ---"; }

# ---------------------------------------------------------------------------
# Read card status once upfront
# ---------------------------------------------------------------------------
echo "=== Yubikey Verification ==="
echo ""
echo "Reading card status..."
CARD_STATUS=$(gpg --card-status 2>&1) || {
  echo "ERROR: gpg --card-status failed. Is a Yubikey inserted?"
  exit 1
}

# ---------------------------------------------------------------------------
# Check 1: Card identity
# ---------------------------------------------------------------------------
sep "Check 1: Card Identity"
SERIAL=$(echo "$CARD_STATUS" | awk '/^Serial number/{print $NF}')
if [ "$SERIAL" = "$YK1_SERIAL" ]; then
  pass "YK1 detected (serial $SERIAL)"
  CARD_NAME="YK1"
elif [ "$SERIAL" = "$YK2_SERIAL" ]; then
  pass "YK2 detected (serial $SERIAL)"
  CARD_NAME="YK2"
else
  fail "Unrecognised serial: '$SERIAL' (expected YK1=$YK1_SERIAL or YK2=$YK2_SERIAL)"
  CARD_NAME="unknown"
fi

# ---------------------------------------------------------------------------
# Check 2: Key slots populated (S, E, A)
# ---------------------------------------------------------------------------
sep "Check 2: Key Slots"
SIG_KEY=$(echo "$CARD_STATUS" | awk '/^Signature key/{print $3}')
ENC_KEY=$(echo "$CARD_STATUS" | awk '/^Encryption key/{print $3}')
AUTH_KEY=$(echo "$CARD_STATUS" | awk '/^Authentication key/{print $3}')

if [ "$SIG_KEY" != "[none]" ] && [ -n "$SIG_KEY" ]; then
  pass "Signature slot populated"
else
  fail "Signature slot is empty"
fi
if [ "$ENC_KEY" != "[none]" ] && [ -n "$ENC_KEY" ]; then
  pass "Encryption slot populated"
else
  fail "Encryption slot is empty"
fi
if [ "$AUTH_KEY" != "[none]" ] && [ -n "$AUTH_KEY" ]; then
  pass "Authentication slot populated"
else
  fail "Authentication slot is empty"
fi

# ---------------------------------------------------------------------------
# Check 3: Key attributes — auth slot should be ed25519
# ---------------------------------------------------------------------------
sep "Check 3: Key Attributes"
AUTH_ATTR=$(echo "$CARD_STATUS" | awk '/Key attributes/{print $NF}')
if echo "$AUTH_ATTR" | grep -qi "ed25519"; then
  pass "Authentication key is ed25519 ($AUTH_ATTR)"
else
  fail "Authentication key attribute unexpected: '$AUTH_ATTR' (expected ed25519)"
fi

# ---------------------------------------------------------------------------
# Check 4: PIN health
# ---------------------------------------------------------------------------
sep "Check 4: PIN Health"
PIN_COUNTERS=$(echo "$CARD_STATUS" | awk '/^PIN retry counter/{print $(NF-2), $(NF-1), $NF}')
USER_PIN=$(echo "$PIN_COUNTERS" | awk '{print $1}')
RESET_CODE=$(echo "$PIN_COUNTERS" | awk '{print $2}')
ADMIN_PIN=$(echo "$PIN_COUNTERS" | awk '{print $3}')

if [ "${USER_PIN:-0}" -ge 1 ]; then
  pass "User PIN retry counter: $USER_PIN"
else
  fail "User PIN retry counter is 0 — PIN may be locked (counter: $USER_PIN)"
fi
if [ "${ADMIN_PIN:-0}" -ge 1 ]; then
  pass "Admin PIN retry counter: $ADMIN_PIN"
else
  fail "Admin PIN retry counter is 0 — Admin PIN may be locked (counter: $ADMIN_PIN)"
fi

# ---------------------------------------------------------------------------
# Check 5: Touch / UIF settings (informational — always passes, just prints)
# ---------------------------------------------------------------------------
sep "Check 5: Touch / UIF Settings"
SIG_UIF=$(echo "$CARD_STATUS" | awk '/^Signature key.*UIF/{print}' | head -1)
ENC_UIF=$(echo "$CARD_STATUS" | awk '/^Encryption key.*UIF/{print}' | head -1)
AUTH_UIF=$(echo "$CARD_STATUS" | awk '/^Authentication key.*UIF/{print}' | head -1)
# Try alternate format (ykman style output not in gpg --card-status, so just check for Touch lines)
UIF_LINES=$(echo "$CARD_STATUS" | grep -i "UIF" || true)
if [ -n "$UIF_LINES" ]; then
  echo "  [INFO] UIF/touch policy lines found in card status"
  pass "Touch policy data readable from card"
else
  echo "  [INFO] No UIF lines in gpg --card-status (normal for OpenPGP applet v2)"
  pass "Touch policy check skipped (not exposed via gpg --card-status)"
fi

# ---------------------------------------------------------------------------
# Check 6: GPG stubs exist in local keyring
# ---------------------------------------------------------------------------
sep "Check 6: GPG Stubs"
GPG_LIST=$(gpg -K "$RECIPIENT" 2>&1) || true
if echo "$GPG_LIST" | grep -q "card-no:"; then
  pass "GPG stubs present for $RECIPIENT (card-no: found in secret keyring)"
elif echo "$GPG_LIST" | grep -q "ssb>"; then
  pass "GPG stubs present for $RECIPIENT (stub marker found)"
else
  fail "GPG stubs missing for $RECIPIENT — run 'gpg --card-status' to materialise them"
  echo "     gpg -K output: $GPG_LIST"
fi

# ---------------------------------------------------------------------------
# Check 7: sshcontrol contains the auth keygrip
# ---------------------------------------------------------------------------
sep "Check 7: sshcontrol"
SSHCONTROL="$HOME/.gnupg/sshcontrol"
if [ -f "$SSHCONTROL" ]; then
  if grep -q "$AUTH_KEYGRIP" "$SSHCONTROL"; then
    pass "sshcontrol contains auth keygrip $AUTH_KEYGRIP"
  else
    fail "sshcontrol exists but does not contain keygrip $AUTH_KEYGRIP"
    echo "     Contents of $SSHCONTROL:"
    cat "$SSHCONTROL" | sed 's/^/     /'
  fi
else
  fail "sshcontrol not found at $SSHCONTROL"
fi

# ---------------------------------------------------------------------------
# Check 8: SSH socket is live
# ---------------------------------------------------------------------------
sep "Check 8: SSH Agent Socket"
SSH_SOCK_PATH=$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null || true)
if [ -n "$SSH_SOCK_PATH" ] && [ -S "$SSH_SOCK_PATH" ]; then
  pass "SSH agent socket is live: $SSH_SOCK_PATH"
else
  fail "SSH agent socket not found or not a socket (path: '$SSH_SOCK_PATH')"
fi

# ---------------------------------------------------------------------------
# Check 9: Correct SSH public key is served
# ---------------------------------------------------------------------------
sep "Check 9: SSH Key Served"
SERVED_KEYS=$(ssh-add -L 2>/dev/null || true)
if echo "$SERVED_KEYS" | grep -q "$EXPECTED_SSH_PUBKEY"; then
  pass "Correct SSH public key is served by the agent"
else
  fail "Expected SSH key not found in agent output"
  echo "     Expected pubkey fragment: ...${EXPECTED_SSH_PUBKEY:0:40}..."
  echo "     Served keys:"
  echo "$SERVED_KEYS" | sed 's/^/     /'
fi

# ---------------------------------------------------------------------------
# Check 10: Encrypt / decrypt round trip
# ---------------------------------------------------------------------------
sep "Check 10: Encrypt/Decrypt Round Trip"
TEST_MSG="yubikey-verify-$(date +%s)-$$"
TMPENC=$(mktemp /tmp/yk-verify-enc.XXXXXX)
TMPDEC=$(mktemp /tmp/yk-verify-dec.XXXXXX)

ENCRYPT_OK=0
echo "$TEST_MSG" | gpg --encrypt --recipient "$RECIPIENT" --batch --yes --output "$TMPENC" 2>/dev/null || ENCRYPT_OK=1

if [ "$ENCRYPT_OK" -ne 0 ]; then
  fail "Encryption failed — cannot encrypt to $RECIPIENT"
  rm -f "$TMPENC" "$TMPDEC"
else
  DECRYPT_OK=0
  gpg --output "$TMPDEC" --yes --decrypt "$TMPENC" 2>/dev/null || DECRYPT_OK=1

  if [ "$DECRYPT_OK" -ne 0 ]; then
    fail "Decryption failed (wrong PIN, card not inserted, or agent issue)"
  else
    DECRYPTED=$(cat "$TMPDEC")
    if [ "$DECRYPTED" = "$TEST_MSG" ]; then
      pass "Encrypt/decrypt round trip successful"
    else
      fail "Decrypted content does not match original message"
    fi
  fi
  rm -f "$TMPENC" "$TMPDEC"
fi

# ---------------------------------------------------------------------------
# Check 11: Key expiry
# ---------------------------------------------------------------------------
sep "Check 11: Key Expiry"
if gpg --list-keys "$RECIPIENT" 2>/dev/null | grep -q "\[expired\]"; then
  fail "One or more keys for $RECIPIENT are expired"
else
  EXPIRY_LINE=$(gpg --list-keys "$RECIPIENT" 2>/dev/null | grep "expires:" | head -1 || true)
  if [ -n "$EXPIRY_LINE" ]; then
    EXPIRY_DATE=$(echo "$EXPIRY_LINE" | grep -oP '(?<=expires: )[0-9-]+' || echo "unknown")
    pass "Key not expired (expires: $EXPIRY_DATE)"
  else
    pass "Key has no expiry date set"
  fi
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "=== Summary ==="
echo "  Card:   ${CARD_NAME:-unknown} (serial: ${SERIAL:-unknown})"
echo "  Passed: $PASS"
echo "  Failed: $FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo "RESULT: FAIL — $FAIL check(s) failed"
  exit 1
else
  echo "RESULT: PASS — all $PASS checks passed"
  exit 0
fi

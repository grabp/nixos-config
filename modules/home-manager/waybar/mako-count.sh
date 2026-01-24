#!/usr/bin/env sh
# Count mako notifications and output JSON for waybar
set +e

if ! command -v makoctl >/dev/null 2>&1; then
  echo "{\"text\": \"\", \"class\": \"none\"}"
  exit 0
fi

# Get count - ignore all errors
count=$(makoctl list 2>/dev/null | grep -c "^Notification" 2>/dev/null || echo 0)

# Clean up: take only the first number, remove all whitespace
count=$(echo "$count" | awk '{print $1}' | tr -d '\n\r\t ')

# Ensure it's a valid number, default to 0
if [ -z "$count" ] || ! [ "$count" -eq "$count" ] 2>/dev/null; then
  count=0
fi

# Output JSON
if [ "$count" -gt 0 ] 2>/dev/null; then
  echo "{\"text\": \"󰂚 $count\", \"class\": \"notification\"}"
else
  echo "{\"text\": \"\", \"class\": \"none\"}"
fi

exit 0

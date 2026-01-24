#!/usr/bin/env sh
# Weather widget for waybar using wttr.in
set +e

if ! command -v curl >/dev/null 2>&1; then
  echo ""
  exit 0
fi

# Fetch weather data with timeout
weather=$(curl -s --max-time 5 'wttr.in?format=%c+%t' 2>/dev/null)

# Check if we got valid data (should contain temperature or emoji)
if [ -z "$weather" ] || [ "$weather" = "Unknown location" ]; then
  echo ""
  exit 0
fi

echo "$weather"
exit 0


#!/usr/bin/env sh
# GPU temperature widget for waybar (AMD GPU)
set +e

TEMP_FILE="/sys/class/hwmon/hwmon0/temp1_input"

if [ ! -f "$TEMP_FILE" ]; then
  echo ""
  exit 0
fi

# Read temperature in millidegrees and convert to Celsius
temp_millidegrees=$(cat "$TEMP_FILE" 2>/dev/null)

if [ -z "$temp_millidegrees" ]; then
  echo ""
  exit 0
fi

# Convert to degrees Celsius
temp_c=$(echo "$temp_millidegrees" | awk '{printf "%.0f", $1/1000}')

# Format output
echo "🎮 ${temp_c}°C"
exit 0


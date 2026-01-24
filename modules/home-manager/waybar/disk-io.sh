#!/usr/bin/env sh
# Disk I/O stats widget for waybar
set +e

DISK="nvme0n1"
STATS_FILE="/proc/diskstats"
CACHE_FILE="/tmp/waybar-disk-io-cache"

# Read current stats
if [ ! -f "$STATS_FILE" ]; then
  echo "📊 R: 0.0M W: 0.0M"
  exit 0
fi

current_stats=$(grep " $DISK " "$STATS_FILE" 2>/dev/null)
if [ -z "$current_stats" ]; then
  echo "📊 R: 0.0M W: 0.0M"
  exit 0
fi

# Extract read and write sectors (fields 6 and 10)
# Each sector is 512 bytes
read_sectors=$(echo "$current_stats" | awk '{print $6}')
write_sectors=$(echo "$current_stats" | awk '{print $10}')

# Check if cache exists
if [ -f "$CACHE_FILE" ]; then
  prev_read=$(awk '{print $1}' "$CACHE_FILE")
  prev_write=$(awk '{print $2}' "$CACHE_FILE")
  prev_time=$(awk '{print $3}' "$CACHE_FILE")
  
  # Calculate time difference (assuming waybar interval is 2 seconds)
  current_time=$(date +%s)
  if [ -n "$prev_time" ] && [ "$prev_time" -gt 0 ]; then
    time_diff=$((current_time - prev_time))
    if [ "$time_diff" -lt 1 ]; then
      time_diff=2
    fi
  else
    time_diff=2
  fi
  
  # Calculate speed in MB/s
  read_diff=$((read_sectors - prev_read))
  write_diff=$((write_sectors - prev_write))
  
  # Convert sectors (512 bytes) to MB and divide by time using awk
  # Use awk to format the entire output to avoid printf issues
  echo "$read_diff $write_diff $time_diff" | awk '{
    read_mbps = ($1 * 512) / 1024 / 1024 / $3
    write_mbps = ($2 * 512) / 1024 / 1024 / $3
    printf "📊 R: %.1fM W: %.1fM\n", read_mbps, write_mbps
  }'
else
  # First run, just show zeros
  echo "📊 R: 0.0M W: 0.0M"
fi

# Save current stats and timestamp
echo "$read_sectors $write_sectors $(date +%s)" > "$CACHE_FILE"

exit 0


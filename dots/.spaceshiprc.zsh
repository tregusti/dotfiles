# Display time
SPACESHIP_TIME_SHOW=true

# Display battery warning when battery is below threshold
SPACESHIP_BATTERY_THRESHOLD=20

if [[ "$(hostname)" != "mb2020.local" ]]; then
  # This sets host to be always displayed when not running on my macbook.
  SPACESHIP_HOST_SHOW="always"
fi

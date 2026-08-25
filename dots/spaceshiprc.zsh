# Display time
SPACESHIP_TIME_SHOW=true

# Display battery warning when battery is below threshold
SPACESHIP_BATTERY_THRESHOLD=20

if [[ "$(hostname)" != "mb2020.local" ]]; then
  # This sets host to be always displayed when not running on my macbook.
  SPACESHIP_HOST_SHOW="always"
fi

# Add a custom vi-mode section to the prompt
# See: https://github.com/spaceship-prompt/spaceship-vi-mode
spaceship remove vi_mode # Remove it if it's already there
spaceship add --before char vi_mode
spaceship_vi_mode_enable

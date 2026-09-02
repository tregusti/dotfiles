-- Hammerspoon config.

-- SpoonInstall: fetches/updates Spoons from the official Spoons repo on load,
-- instead of manually unzipping into ~/.hammerspoon/Spoons/. Only knows about
-- Spoons listed at https://www.hammerspoon.org/Spoons/ — anything else still
-- needs a manual clone/symlink into Spoons/.
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

local Install = spoon.SpoonInstall

-- andUse() only installs a Spoon the first time it's missing; it won't fetch
-- newer versions on later reloads. Check for updates to installed Spoons weekly.
local WEEK_SECONDS = 7 * 24 * 60 * 60
hs.timer.doEvery(WEEK_SECONDS, function()
  Install:updateAllSpoons()
end)

-- Reload config wheen this file is saved.
Install:andUse("ReloadConfiguration", { start = true })

require("dropbox.screenshot-watcher")

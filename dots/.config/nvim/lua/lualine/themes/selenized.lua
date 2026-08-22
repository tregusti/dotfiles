-- Shadows maxmx03/solarized.nvim's bundled lualine/themes/selenized.lua.
--
-- lualine's loader prefers a theme file found under the user's config
-- runtimepath over one bundled with a plugin (see
-- lualine/utils/loader.lua's `load_theme`), so this file wins for
-- `theme = 'selenized'` in lualine.lua.
--
-- Upstream bug this works around: solarized.nvim's own selenized.lua (and
-- solarized.lua) `require 'solarized.palette'` in BOTH the dark and light
-- branches, so the light branch never actually reads the light palette
-- module (`solarized.palette.solarized-light`) — the mode/location
-- segment's blue stayed dark-mode blue even after switching to
-- `vim.o.background = 'light'`. Fixed here by requiring the correct module
-- per branch. Reported upstream:
-- https://github.com/maxmx03/solarized.nvim/issues/109 — drop this file
-- once that's fixed and released.
if vim.o.background == 'dark' then
  local c = require('solarized.palette').selenized
  return {
    normal = {
      a = { fg = c.base03, bg = c.blue, gui = 'bold' },
      b = { fg = c.base02, bg = c.base1 },
      c = { fg = c.base1, bg = c.base02 },
      z = { fg = c.base03, bg = c.blue },
    },
    insert = {
      a = { fg = c.base03, bg = c.green },
    },
    visual = {
      a = { fg = c.base03, bg = c.magenta },
    },
    replace = {
      a = { fg = c.base03, bg = c.red },
    },
    command = {
      a = { fg = c.base03, bg = c.orange },
    },
  }
else
  local c = require('solarized.palette.solarized-light').selenized
  return {
    normal = {
      a = { fg = c.base3, bg = c.blue, gui = 'bold' },
      b = { fg = c.base2, bg = c.base01 },
      c = { fg = c.base01, bg = c.base2 },
      z = { fg = c.base3, bg = c.blue },
    },
    insert = {
      a = { fg = c.base3, bg = c.green },
    },
    visual = {
      a = { fg = c.base3, bg = c.magenta },
    },
    replace = {
      a = { fg = c.base3, bg = c.red },
    },
    command = {
      a = { fg = c.base3, bg = c.orange },
    },
  }
end

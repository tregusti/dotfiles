-- Neovim entry point.
--
-- Read order matters:
--   1. leader keys — MUST be set before lazy.nvim loads, so that any plugin
--      keymaps using <leader> resolve correctly. :help mapleader
--   2. options    — editor behaviour (see lua/config/options.lua)
--   3. keymaps    — non-plugin key mappings (see lua/config/keymaps.lua)
--   4. lazy       — bootstraps the plugin manager and imports lua/plugins/*
--
-- This config is seeded from kickstart.nvim (https://github.com/nvim-lua/kickstart.nvim)
-- but re-authored into small modules. See README.md for the map and docs/adr/ for
-- the decisions behind it.

-- Space as leader (matches the previous Vim config). :help mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- We have a Nerd Font installed (see README dependencies) so plugins may use
-- glyph icons. :help vim.g
vim.g.have_nerd_font = true

require('config.options')
require('config.keymaps')
require('config.buffers')
require('config.window-dim')
require('config.lazy')

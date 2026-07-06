-- Bootstrap and configure lazy.nvim, the plugin manager.
--
-- Docs: https://lazy.folke.io/  (installation + spec format)
-- Why lazy.nvim: see docs/adr/0002-modular-config-seeded-from-kickstart.md
--
-- lazy.nvim installs plugins OUTSIDE this repo, under stdpath('data')
-- (~/.local/share/nvim/lazy), so there's nothing plugin-related to gitignore here.
-- The resolved versions are pinned in lazy-lock.json (committed) for reproducibility.

-- Auto-install lazy.nvim itself on first launch if it isn't present.
-- https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- `import = 'plugins'` loads every module under lua/plugins/*.lua. Each returns a
-- lazy.nvim plugin spec (or a list of them). :help lazy.nvim-🔌-plugin-spec
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  -- Use the chosen colorscheme while plugins install on first run.
  install = { colorscheme = { 'tokyonight' } },
  -- Notify when a plugin has an update available (check manually with :Lazy).
  checker = { enabled = true, notify = false },
  ui = {
    -- Only use fancy icons if a Nerd Font is present.
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})

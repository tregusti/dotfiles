-- Colorscheme: Solarized, following the OS light/dark setting.
--
-- Chosen for the warm Solarized feel (tokyonight's dark palette read as too cold/
-- blue). maxmx03/solarized.nvim is a modern Lua port with Treesitter + LSP semantic
-- highlighting and a lualine integration. It switches on `vim.o.background`, so the
-- auto-dark-mode plugin below flips it between Solarized dark and Solarized light.
--
-- solarized.nvim docs: https://github.com/maxmx03/solarized.nvim
-- auto-dark-mode docs: https://github.com/f-person/auto-dark-mode.nvim

return {
  {
    'maxmx03/solarized.nvim',
    lazy = false,      -- load during startup (it's the UI). :help lazy.nvim-uiplugins
    priority = 1000,   -- load before other plugins so highlights exist first.
    ---@type solarized.config
    opts = {},         -- defaults; palette follows vim.o.background. :help solarized.nvim
    config = function(_, opts)
      require('solarized').setup(opts)
      vim.cmd.colorscheme('solarized')
    end,
  },
  {
    -- Watches the macOS appearance setting and flips background light/dark, which
    -- makes Solarized switch automatically. Follows OS-level only.
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    priority = 999,    -- after the colorscheme is registered.
    opts = {
      update_interval = 3000,  -- ms between checks of the OS setting.
      set_dark_mode = function()
        vim.o.background = 'dark'  -- Solarized dark. :help 'background'
      end,
      set_light_mode = function()
        vim.o.background = 'light' -- Solarized light.
      end,
    },
  },
}

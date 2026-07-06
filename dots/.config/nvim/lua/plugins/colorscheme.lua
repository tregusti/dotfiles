-- Colorscheme: tokyonight, following the OS light/dark setting.
--
-- Decision: docs/adr/ (appearance) — tokyonight-day ≈ light Solarized,
-- tokyonight-night ≈ dark Solarized, which keeps continuity with the old config.
--
-- tokyonight docs: https://github.com/folke/tokyonight.nvim
-- auto-dark-mode docs: https://github.com/f-person/auto-dark-mode.nvim

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,      -- load during startup (it's the UI). :help lazy.nvim-uiplugins
    priority = 1000,   -- load before other plugins so highlights exist first.
    config = function()
      require('tokyonight').setup({
        -- 'day' when background=light, 'night'/'storm'/'moon' when dark.
        -- auto-dark-mode (below) flips vim.o.background; tokyonight reacts to it.
        style = 'night',       -- dark variant to use. :help tokyonight
        light_style = 'day',   -- variant used when background = 'light'.
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  {
    -- Watches the macOS appearance setting and flips background light/dark, which
    -- makes tokyonight switch day/night automatically. Follows OS-level only.
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    priority = 999,    -- after the colorscheme is registered.
    opts = {
      update_interval = 3000,  -- ms between checks of the OS setting.
      set_dark_mode = function()
        vim.o.background = 'dark'  -- tokyonight -> night. :help 'background'
      end,
      set_light_mode = function()
        vim.o.background = 'light' -- tokyonight -> day.
      end,
    },
  },
}

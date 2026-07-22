-- Colorscheme: Solarized, following the OS light/dark setting.
--
-- Chosen for the warm Solarized feel (tokyonight's dark palette read as too cold/
-- blue). maxmx03/solarized.nvim is a modern Lua port with Treesitter + LSP semantic
-- highlighting and a lualine integration. It switches on `vim.o.background`, so the
-- auto-dark-mode plugin below flips it between Solarized dark and Solarized light.
--
-- solarized.nvim docs: https://github.com/maxmx03/solarized.nvim
-- auto-dark-mode docs: https://github.com/f-person/auto-dark-mode.nvim

-- Solarized's diff-related groups are `fg`-only (some also `reverse`), so
-- they render as a solid color block with no syntax highlighting underneath.
-- Redefine them `bg`-only, using the theme's own pre-mixed `mix_*` tones, so
-- syntax colors stay visible and only a background tint is added.
local function tint_diff_highlights()
  local palette_name = require('solarized').config.palette
  local colors = vim.o.background == 'dark' and require('solarized.palette')[palette_name]
    or require('solarized.palette.solarized-light')[palette_name]

  -- git.lua `linehl`: whole changed line, in a normal buffer.
  vim.api.nvim_set_hl(0, 'GitSignsAddLn', { bg = colors.mix_green })
  vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { bg = colors.mix_yellow })
  vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', { bg = colors.mix_yellow })
  vim.api.nvim_set_hl(0, 'GitSignsUntrackedLn', { bg = colors.mix_green })

  -- Native Neovim diff mode (`:diffthis` / `:Gitsigns diffthis` / agent.lua
  -- Claude diff splits): whole line, plus the changed word via DiffText.
  vim.api.nvim_set_hl(0, 'DiffAdd', { bg = colors.mix_green })
  vim.api.nvim_set_hl(0, 'DiffChange', { bg = colors.mix_yellow })
  vim.api.nvim_set_hl(0, 'DiffDelete', { bg = colors.mix_red })
  vim.api.nvim_set_hl(0, 'DiffText', { bg = colors.mix_orange })

  -- git.lua `word_diff`: the changed word, in a normal buffer (separate
  -- highlight chain from DiffText above; defaults to a `Cursor` block).
  vim.api.nvim_set_hl(0, 'GitSignsAddInline', { bg = colors.mix_green })
  vim.api.nvim_set_hl(0, 'GitSignsChangeInline', { bg = colors.mix_orange })
  vim.api.nvim_set_hl(0, 'GitSignsDeleteInline', { bg = colors.mix_red })
end

return {
  {
    'maxmx03/solarized.nvim',
    lazy = false, -- load during startup (it's the UI). :help lazy.nvim-uiplugins
    priority = 1000, -- load before other plugins so highlights exist first.
    ---@type solarized.config
    opts = {}, -- defaults; palette follows vim.o.background. :help solarized.nvim
    config = function(_, opts)
      require('solarized').setup(opts)
      vim.cmd.colorscheme('solarized')
      tint_diff_highlights()
      -- Reapply on every reload (e.g. auto-dark-mode flipping light/dark),
      -- since `:colorscheme` runs `hi clear` and wipes these overrides.
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'solarized',
        callback = tint_diff_highlights,
      })
    end,
  },
  {
    -- Watches the macOS appearance setting and flips background light/dark, which
    -- makes Solarized switch automatically. Follows OS-level only.
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    priority = 999, -- after the colorscheme is registered.
    opts = {
      update_interval = 3000, -- ms between checks of the OS setting.
      set_dark_mode = function()
        vim.o.background = 'dark' -- Solarized dark. :help 'background'
      end,
      set_light_mode = function()
        vim.o.background = 'light' -- Solarized light.
      end,
    },
  },
}

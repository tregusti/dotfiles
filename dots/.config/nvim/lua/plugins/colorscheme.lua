-- Colorscheme: Solarized, following the OS light/dark setting.
--
-- Chosen for the warm Solarized feel (tokyonight's dark palette read as too cold/
-- blue). maxmx03/solarized.nvim is a modern Lua port with Treesitter + LSP semantic
-- highlighting and a lualine integration. It switches on `vim.o.background`, so the
-- auto-dark-mode plugin below flips it between Solarized dark and Solarized light.
--
-- solarized.nvim docs: https://github.com/maxmx03/solarized.nvim
-- auto-dark-mode docs: https://github.com/f-person/auto-dark-mode.nvim

-- Blends `fg_hex` toward `bg_hex` by `alpha` (0-1); used to make the number-
-- column tint stronger than Solarized's own (too-subtle) `mix_*` colors.
local function blend(fg_hex, bg_hex, alpha)
  local function to_rgb(hex)
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
  end
  local fr, fg, fb = to_rgb(fg_hex)
  local br, bg, bb = to_rgb(bg_hex)
  return string.format(
    '#%02x%02x%02x',
    math.floor(fr * alpha + br * (1 - alpha) + 0.5),
    math.floor(fg * alpha + bg * (1 - alpha) + 0.5),
    math.floor(fb * alpha + bb * (1 - alpha) + 0.5)
  )
end

-- Change/diff indication lives in two places only: the number column (solid
-- badge) and the changed word itself (subtle bg tint) — the line's own bg/fg
-- stay untouched so syntax highlighting is never overridden.
local function tint_diff_highlights()
  local palette_name = require('solarized').config.palette
  local colors = vim.o.background == 'dark' and require('solarized.palette')[palette_name]
    or require('solarized.palette.solarized-light')[palette_name]

  -- git.lua `numhl`: number column only (bold bg + sharp fg), line untouched.
  -- 0.45 blend toward the editor bg — stronger than Solarized's own `mix_*`,
  -- tune this number up/down if it's still too loud/subtle.
  local numhl_bg_alpha = 0.20
  local editor_bg = vim.o.background == 'dark' and colors.base03 or colors.base3
  local add_bg = blend(colors.git_add, editor_bg, numhl_bg_alpha)
  local change_bg = blend(colors.git_modify, editor_bg, numhl_bg_alpha)
  vim.api.nvim_set_hl(0, 'GitSignsAddNr', { bg = add_bg, fg = colors.git_add })
  vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { bg = change_bg, fg = colors.git_modify })
  vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { bg = change_bg, fg = colors.git_modify })
  vim.api.nvim_set_hl(0, 'GitSignsUntrackedNr', { bg = add_bg, fg = colors.git_add })

  -- git.lua `linehl`: added lines only get a full-line bg tint (GitSignsAddLn
  -- also covers GitSignsUntrackedLn, which falls back to it). Changed lines
  -- deliberately have no line-level group here, so they fall through to
  -- DiffChange below (Normal) — word_diff/DiffText is their only indicator.
  vim.api.nvim_set_hl(0, 'GitSignsAddLn', { bg = colors.mix_green })

  -- Native Neovim diff mode (`:diffthis` / `:Gitsigns diffthis` / agent.lua
  -- Claude diff splits) has no number-column groups, only whole-line ones.
  -- DiffAdd mirrors GitSignsAddLn above; DiffChange/DiffDelete stay untouched
  -- (Normal) so DiffText remains the only marker on changed lines.
  vim.api.nvim_set_hl(0, 'DiffAdd', { bg = colors.mix_green })
  vim.api.nvim_set_hl(0, 'DiffChange', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'DiffDelete', { link = 'Normal' })
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

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

-- Solarized doesn't ship the gitsigns highlight groups modern themes bundle
-- out of the box, so this fills the gap by hand. Change/diff indication
-- lives in two places only: the number column (solid badge) and the changed
-- word itself (subtle bg tint) — the line's own bg/fg stay untouched so
-- syntax highlighting is never overridden.
local function tint_diff_highlights()
  local palette_name = require('solarized').config.palette
  local colors = vim.o.background == 'dark' and require('solarized.palette')[palette_name]
    or require('solarized.palette.solarized-light')[palette_name]

  -- 0.45 blend toward the editor bg, for the number-column badge below —
  -- stronger than Solarized's own `mix_*`, tune up/down if still too loud/subtle.
  local numhl_bg_alpha = 0.25
  local editor_bg = vim.o.background == 'dark' and colors.base03 or colors.base3
  local add_bg = blend(colors.git_add, editor_bg, numhl_bg_alpha)
  local change_bg = blend(colors.git_modify, editor_bg, numhl_bg_alpha)

  -- Each group below is { highlight name, attrs }. Grouped by which git.lua
  -- option (or feature) drives it; see the comment above each block.
  local groups = {
    -- `numhl`: number column only (bold bg + sharp fg) — the line itself is
    -- untouched, so this is the only per-line status indicator on offer.
    { 'GitSignsAddNr', { bg = add_bg, fg = colors.git_add } },
    { 'GitSignsChangeNr', { bg = change_bg, fg = colors.git_modify } },
    { 'GitSignsChangedeleteNr', { bg = change_bg, fg = colors.git_modify } },
    { 'GitSignsUntrackedNr', { bg = add_bg, fg = colors.git_add } },

    -- `linehl`: added lines get a full-line bg tint (GitSignsAddLn also covers
    -- GitSignsUntrackedLn via fallback). Changed lines get a truly empty group
    -- — not `link = 'Normal'`, since Normal has an explicit `fg` that would
    -- flatten every token on the line to one color — so word_diff/DiffText
    -- (below) stays the only indicator there, with syntax colors untouched.
    { 'GitSignsAddLn', { bg = colors.mix_green } },
    { 'GitSignsChangeLn', {} },
    { 'GitSignsChangedeleteLn', {} },

    -- Native Neovim diff mode (`:diffthis` / `:Gitsigns diffthis` / agent.lua
    -- Claude diff splits) has no number-column groups, only whole-line ones:
    -- DiffAdd mirrors GitSignsAddLn, DiffChange/DiffDelete stay empty for the
    -- same reason as above, DiffText marks the changed word.
    { 'DiffAdd', { bg = colors.mix_green } },
    { 'DiffChange', {} },
    { 'DiffDelete', {} },
    { 'DiffText', { bg = colors.mix_orange } },

    -- `word_diff`: the changed word, in a normal buffer — a separate
    -- highlight chain from DiffText above (defaults to a `Cursor` block).
    { 'GitSignsAddInline', { bg = colors.mix_green } },
    { 'GitSignsChangeInline', { bg = colors.mix_orange } },
    { 'GitSignsDeleteInline', { bg = colors.mix_red } },

    -- `<leader>hp` hunk-preview popup: its own groups, not DiffAdd/DiffDelete
    -- (deliberately emptied above) — so removed/added lines there keep a
    -- full-line bg regardless of what the main buffer does.
    { 'GitSignsAddPreview', { bg = colors.mix_green } },
    { 'GitSignsDeletePreview', { bg = colors.mix_red } },
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group[1], group[2])
  end
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

-- Statusline: lualine (replaces the old vim-airline).
--
-- lualine themes itself from the active colorscheme (theme = 'auto'), so it tracks
-- the active colorscheme's dark/light automatically.
--
-- Docs: https://github.com/nvim-lualine/lualine.nvim

local in_tmux = vim.env.TMUX ~= nil

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- filetype glyphs (needs a Nerd Font).
  opts = {
    options = {
      -- Not 'auto': lualine's auto-theme keys off `vim.g.colors_name`, which
      -- solarized.nvim always sets to 'solarized' regardless of the chosen
      -- `palette` option — so 'auto' would load solarized.nvim's bundled
      -- lualine/themes/solarized.lua (hardcoded to classic Solarized blue)
      -- instead of themes/selenized.lua, mismatching tmux's Selenized blue.
      theme = 'selenized',
      icons_enabled = vim.g.have_nerd_font,
      component_separators = '|',
      section_separators = '', -- flat look; set to powerline arrows if you prefer.
    },
    -- Deviation from the default layout: 'diff' and 'diagnostics' normally sit
    -- in section b, whose grey background makes solarized's accent colours
    -- (red especially) near unreadable. Section c uses the editor background,
    -- the surface those colours are designed against, so the colour-coded
    -- components live there instead. :help lualine-Default-configuration
    sections = in_tmux and {
      -- No git info in tmux since tmux status bar provides that.
      lualine_b = {},
      lualine_c = {
        'diagnostics',
        { 'filename', path = 1 },
      },
    } or {
      lualine_b = { 'branch' },
      lualine_c = {
        'diff',
        'diagnostics',
        { 'filename', path = 1 },
      },
    },
  },
}

-- Statusline: lualine (replaces the old vim-airline).
--
-- lualine themes itself from the active colorscheme (theme = 'auto'), so it tracks
-- the active colorscheme's dark/light automatically.
--
-- Docs: https://github.com/nvim-lualine/lualine.nvim

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- filetype glyphs (needs a Nerd Font).
  opts = {
    options = {
      theme = 'auto',            -- derive colours from the active colorscheme.
      icons_enabled = vim.g.have_nerd_font,
      globalstatus = true,       -- one statusline for all splits. :help 'laststatus'
      component_separators = '|',
      section_separators = '',   -- flat look; set to powerline arrows if you prefer.
    },
    -- Default section layout: mode | branch,diff,diagnostics | filename | encoding,
    -- filetype | progress | location. See :help lualine-Default-configuration for
    -- the meaning of each section a/b/c/x/y/z.
  },
}

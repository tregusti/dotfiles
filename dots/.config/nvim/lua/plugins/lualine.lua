-- Statusline: lualine (replaces the old vim-airline).
--
-- lualine themes itself from the active colorscheme (theme = 'auto'), so it tracks
-- the active colorscheme's dark/light automatically.
--
-- Docs: https://github.com/nvim-lualine/lualine.nvim

-- Repo-wide dirty count: how many files `git status` would list. This is the
-- equivalent of VS Code's source-control badge, as a reminder that something
-- needs committing. The built-in 'diff' component only covers the current
-- buffer's hunks, not the repository.
--
-- The count is cached and refreshed on the events below. Running git on every
-- statusline redraw would lag, so the component itself only reads the cache.
local dirty_count = nil

local function refresh_dirty_count()
  vim.system({ 'git', 'status', '--porcelain' }, { text = true }, function(out)
    if out.code == 0 then
      local n = 0
      for _ in (out.stdout or ''):gmatch('[^\r\n]+') do
        n = n + 1
      end
      dirty_count = n
    else
      dirty_count = nil -- not inside a git repository
    end
  end)
end

local group = vim.api.nvim_create_augroup('lualine-dirty-count', {})

vim.api.nvim_create_autocmd(
  { 'VimEnter', 'FocusGained', 'BufWritePost', 'DirChanged', 'TermClose' },
  { group = group, callback = refresh_dirty_count }
)

-- Committing inside Neogit changes no files and never drops focus, so listen
-- for its own refresh signal too.
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'NeogitStatusRefreshed',
  callback = refresh_dirty_count,
})

local uncommitted = {
  function()
    return '±' .. dirty_count .. ' files'
  end,
  cond = function()
    return (dirty_count or 0) > 0
  end,
  -- Warning-sign badge: dark text on the palette's warning yellow (~5:1
  -- contrast). Resolved from the active solarized palette at draw time, so it
  -- follows background and palette switches. A distinct bg also makes lualine
  -- drop the adjacent '|' by design; the coloured block separates itself.
  color = function()
    local c = require('solarized.utils').get_colors()
    return { fg = c.base3, bg = c.diag_warning }
  end,
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- filetype glyphs (needs a Nerd Font).
  opts = {
    options = {
      theme = 'auto', -- derive colours from the active colorscheme.
      icons_enabled = vim.g.have_nerd_font,
      globalstatus = true, -- one statusline for all splits. :help 'laststatus'
      component_separators = '|',
      section_separators = '', -- flat look; set to powerline arrows if you prefer.
    },
    -- Deviation from the default layout: 'diff' and 'diagnostics' normally sit
    -- in section b, whose grey background makes solarized's accent colours
    -- (red especially) near unreadable. Section c uses the editor background,
    -- the surface those colours are designed against, so the colour-coded
    -- components live there instead. :help lualine-Default-configuration
    sections = {
      lualine_b = { 'branch' },
      lualine_c = { uncommitted, 'diff', 'diagnostics', { 'filename', path = 1 } },
    },
  },
}

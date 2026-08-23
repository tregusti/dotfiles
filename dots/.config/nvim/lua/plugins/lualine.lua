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

local in_tmux = vim.env.TMUX ~= nil

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

-- WinEnter catches the git workflow this config actually uses: committing via
-- `git commit` in the toggleable terminal (terminal.lua) changes no buffer
-- (no BufWritePost) and never leaves the OS window (no FocusGained) — toggling
-- the terminal closed re-enters the previous window instead, which WinEnter
-- does catch.
vim.api.nvim_create_autocmd(
  { 'VimEnter', 'FocusGained', 'WinEnter', 'BufWritePost', 'DirChanged', 'TermClose' },
  { group = group, callback = refresh_dirty_count }
)

-- Winbar highlight, active vs inactive. Every component below (including the
-- '%=' centering markers) is painted with the SAME highlight so the strip
-- reads as one solid-colour bar rather than just the filename text having a
-- background — an unterminated %#hl# span fills the gap vim inserts at a
-- '%=' split point with whatever highlight preceded it, so colouring the
-- fillers too is what makes the color cover the full window width.
local function winbar_hl(which)
  return function()
    local c = require('solarized.utils').get_colors()
    local dark = vim.o.background == 'dark'
    if which == 'active' then
      return {
        fg = dark and c.base03 or c.base3,
        -- Red instead of blue inside tmux: blue is already tmux's own
        -- status-bar accent (see tmux.conf), so the active winbar needs a
        -- different color there to still read as a distinct signal.
        bg = in_tmux and c.red or c.blue,
      }
    else
      return {
        fg = dark and c.base1 or c.base01,
        bg = dark and c.base02 or c.base2,
      }
    end
  end
end

-- Builds one winbar's component list (active or inactive), sharing one
-- highlight across all four entries so the whole row is a single colour.
local function winbar_components(which)
  local hl = winbar_hl(which)
  return {
    { '%=', color = hl, separator = '' },
    {
      'filetype',
      icon_only = true,
      colored = false, -- keep the icon on the shared bar colour, not devicons' per-language colour
      padding = { left = 0, right = 1 },
      color = hl,
      separator = '',
    },
    {
      'filename',
      path = 0,
      symbols = { modified = ' ●', readonly = ' ', unnamed = '' },
      color = hl,
      separator = '',
    },
    { '%=', color = hl, separator = '' },
  }
end

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
      -- Not 'auto': lualine's auto-theme keys off `vim.g.colors_name`, which
      -- solarized.nvim always sets to 'solarized' regardless of the chosen
      -- `palette` option — so 'auto' would load solarized.nvim's bundled
      -- lualine/themes/solarized.lua (hardcoded to classic Solarized blue)
      -- instead of themes/selenized.lua, mismatching tmux's Selenized blue.
      theme = 'selenized',
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
      lualine_b = in_tmux and {} or { 'branch' },
      lualine_c = in_tmux and {
        'diagnostics',
        { 'filename', path = 1 },
      } or {
        uncommitted,
        'diff',
        'diagnostics',
        { 'filename', path = 1 },
      },
    },
    -- Per-window filename, pinned to the top of each split. Needed because
    -- globalstatus above collapses the statusline itself to one shared bar,
    -- which otherwise leaves no per-window indication of which file is where.
    --
    -- Centered via literal '%=' components either side: lualine builds the
    -- winbar as a plain statusline-format string under the hood, so '%='
    -- works here the same way it does in 'statusline' — an even split point,
    -- one on each side, centers whatever sits between them.
    winbar = {
      lualine_c = winbar_components('active'),
    },
    inactive_winbar = {
      lualine_c = winbar_components('inactive'),
    },
  },
}

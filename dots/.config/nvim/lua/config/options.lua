-- Editor options.
--
-- Every option is citable with `:help '<name>'` inside Neovim (run it — that's the
-- manual for your exact version). `vim.opt` is the Lua interface to these; see
-- `:help vim.opt` and `:help lua-options`.
--
-- These are the confirmed, non-fluency-dependent settings. Anything to do with
-- keymaps / folding ergonomics lives elsewhere and is being revisited after the
-- Vim teach session.

local opt = vim.opt

-- Line numbers -------------------------------------------------------------------

-- Absolute number on the current line. :help 'number'
opt.number = true
-- Relative numbers on the others, for quick j/k jumps. :help 'relativenumber'
opt.relativenumber = true

-- Indentation (matches .editorconfig: 2 spaces) ----------------------------------

-- Tabs insert spaces. :help 'expandtab'
opt.expandtab = true
-- Indent width for >>, <<, ==, autoindent. :help 'shiftwidth'
opt.shiftwidth = 2
-- A <Tab> renders as 2 columns. :help 'tabstop'
opt.tabstop = 2
-- A <Tab> keypress feels like 2 spaces. :help 'softtabstop'
opt.softtabstop = 2
-- Language-aware auto-indent on new lines. :help 'smartindent'
opt.smartindent = true
-- Note: editorconfig support is built in to Neovim >= 0.9, so per-project overrides
-- in a repo's .editorconfig win over the above. :help editorconfig

-- Search -------------------------------------------------------------------------

-- Case-insensitive search... :help 'ignorecase'
opt.ignorecase = true
-- ...unless the pattern contains a capital. :help 'smartcase'
opt.smartcase = true
-- Highlight all matches. :help 'hlsearch'
opt.hlsearch = true
-- Show matches as you type. :help 'incsearch'
opt.incsearch = true
-- Live preview of :substitute in a split. :help 'inccommand'
opt.inccommand = 'split'

-- UI -----------------------------------------------------------------------------

-- 24-bit colour (required by modern colorschemes). :help 'termguicolors'
opt.termguicolors = true
-- Default border for floating windows (LSP hover, signature help, diagnostics,
-- :checkhealth, ...) that don't set their own. :help 'winborder'
opt.winborder = 'rounded'
-- Named the terminal-mode cursor. Default guicursor omits a highlight group for
-- the other modes, so Neovim never sends the OSC 12 escape sequence that tells
-- the terminal (Ghostty) to color the cursor from the colorscheme's 'Cursor'
-- highlight — it falls back to the terminal's own default (often a plain white
-- block, wrong on a light background). :help 'guicursor'
opt.guicursor = 'n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,'
  .. 'r-cr-o:hor20-Cursor/lCursor,t:block-blinkon500-blinkoff500-TermCursor'
-- Highlight the line the cursor is on. :help 'cursorline'
opt.cursorline = true
-- Always show the sign column so text doesn't jump when diagnostics/git signs
-- appear. :help 'signcolumn'
opt.signcolumn = 'yes'
-- Keep 10 lines of context above/below the cursor. :help 'scrolloff'
opt.scrolloff = 10
-- Don't soft-wrap long lines. :help 'wrap'
opt.wrap = false
-- Mode is shown in lualine, so hide the default -- INSERT --. :help 'showmode'
opt.showmode = false
-- Show otherwise-invisible whitespace... :help 'list'
opt.list = true
-- ...like this. :help 'listchars'
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Folding (source is wired per-filetype in plugins/treesitter.lua) --------------

-- Start with all folds open; nothing pre-collapsed on open. :help 'foldlevel'
opt.foldlevel = 99
-- ...same, for the first window of a new buffer. :help 'foldlevelstart'
opt.foldlevelstart = 99
-- Folds are usable (za/zo/zc/zR/zM) even though none start closed.
-- :help 'foldenable'
opt.foldenable = true
-- Fold gutter, chevrons below; collapses to width 0 in buffers with no folds.
-- :help 'foldcolumn'
opt.foldcolumn = 'auto:1'
-- :help 'fillchars'
-- foldinner: without this, a line inside an open fold but not itself a
-- fold-start shows the numeric fold level instead of blank, when
-- foldcolumn is too narrow to draw one symbol per nesting level.
opt.fillchars:append(
  -- VS Code-style chevrons (glyphs verified against kevinhwang91/nvim-ufo README).
  vim.g.have_nerd_font and { foldopen = '', foldclose = '', foldsep = ' ', foldinner = ' ' }
    -- ASCII fallback.
    or { foldopen = '-', foldclose = '+', foldsep = '|', foldinner = ' ' }
)

-- Splits (open where the eye expects) --------------------------------------------

-- Vertical splits open to the right. :help 'splitright'
opt.splitright = true
-- Horizontal splits open below. :help 'splitbelow'
opt.splitbelow = true

-- Files & undo -------------------------------------------------------------------

-- Reload a buffer if its file changed on disk and the buffer has no unsaved
-- changes. :help 'autoread'
opt.autoread = true
-- No .swp files (matches old config). :help 'swapfile'
opt.swapfile = false
-- Persist undo history across sessions to disk. :help 'undofile'
opt.undofile = true
-- On :q with unsaved changes, prompt instead of hard-erroring. :help 'confirm'
-- (still prevents accidental data loss — it asks, it never silently discards.)
opt.confirm = true

-- Behaviour ----------------------------------------------------------------------

-- Mouse enabled in all modes. :help 'mouse'
opt.mouse = 'a'
-- Use the OS clipboard for yank/paste. :help 'clipboard'
-- (Scheduled after startup by kickstart to avoid slowing launch; here we set it
-- directly — fine on a desktop.)
opt.clipboard = 'unnamedplus'
-- Faster CursorHold (used by diagnostics/git). :help 'updatetime'
opt.updatetime = 250
-- Ms to wait for a mapped sequence (which-key hints). :help 'timeoutlen'
opt.timeoutlen = 300
-- Wrapped lines keep their indent (readability). :help 'breakindent'
opt.breakindent = true

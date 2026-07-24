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
opt.number = true            -- absolute number on the current line. :help 'number'
opt.relativenumber = true    -- relative numbers on the others, for quick j/k jumps.
                             -- :help 'relativenumber'

-- Indentation (matches .editorconfig: 2 spaces) ----------------------------------
opt.expandtab = true         -- tabs insert spaces. :help 'expandtab'
opt.shiftwidth = 2           -- indent width for >>, <<, ==, autoindent. :help 'shiftwidth'
opt.tabstop = 2              -- a <Tab> renders as 2 columns. :help 'tabstop'
opt.softtabstop = 2          -- a <Tab> keypress feels like 2 spaces. :help 'softtabstop'
opt.smartindent = true       -- language-aware auto-indent on new lines. :help 'smartindent'
-- Note: editorconfig support is built in to Neovim >= 0.9, so per-project overrides
-- in a repo's .editorconfig win over the above. :help editorconfig

-- Search -------------------------------------------------------------------------
opt.ignorecase = true        -- case-insensitive search... :help 'ignorecase'
opt.smartcase = true         -- ...unless the pattern contains a capital. :help 'smartcase'
opt.hlsearch = true          -- highlight all matches. :help 'hlsearch'
opt.incsearch = true         -- show matches as you type. :help 'incsearch'
opt.inccommand = 'split'     -- live preview of :substitute in a split. :help 'inccommand'

-- UI -----------------------------------------------------------------------------
opt.termguicolors = true     -- 24-bit colour (required by modern colorschemes). :help 'termguicolors'
opt.winborder = 'rounded'    -- default border for floating windows (LSP hover, signature
                             -- help, diagnostics, :checkhealth, ...) that don't set their
                             -- own. :help 'winborder'
opt.guicursor = 'n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,'
  .. 'r-cr-o:hor20-Cursor/lCursor,t:block-blinkon500-blinkoff500-TermCursor'
  -- Named the terminal-mode cursor. Default guicursor omits a highlight group
  -- for the other modes, so Neovim never sends the OSC 12 escape sequence that
  -- tells the terminal (Ghostty) to color the cursor from the colorscheme's
  -- 'Cursor' highlight — it falls back to the terminal's own default (often a
  -- plain white block, wrong on a light background). :help 'guicursor'
opt.cursorline = true        -- highlight the line the cursor is on. :help 'cursorline'
opt.signcolumn = 'yes'       -- always show the sign column so text doesn't jump when
                             -- diagnostics/git signs appear. :help 'signcolumn'
opt.scrolloff = 10           -- keep 10 lines of context above/below the cursor. :help 'scrolloff'
opt.wrap = false             -- don't soft-wrap long lines. :help 'wrap'
opt.showmode = false         -- mode is shown in lualine, so hide the default -- INSERT --.
                             -- :help 'showmode'
opt.list = true              -- show otherwise-invisible whitespace... :help 'list'
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- ...like this. :help 'listchars'

-- Folding (source is wired per-filetype in plugins/treesitter.lua) --------------
opt.foldlevel = 99           -- start with all folds open; nothing pre-collapsed on
                             -- open. :help 'foldlevel'
opt.foldlevelstart = 99      -- ...same, for the first window of a new buffer.
                             -- :help 'foldlevelstart'
opt.foldenable = true        -- folds are usable (za/zo/zc/zR/zM) even though none
                             -- start closed. :help 'foldenable'
opt.foldcolumn = 'auto:1'    -- fold gutter, chevrons below; collapses to width 0
                             -- in buffers with no folds. :help 'foldcolumn'
opt.fillchars:append(vim.g.have_nerd_font
  and { foldopen = '', foldclose = '', foldsep = ' ', foldinner = ' ' } -- VS Code-style chevrons (glyphs verified against kevinhwang91/nvim-ufo README).
  or { foldopen = '-', foldclose = '+', foldsep = '|', foldinner = ' ' } -- ASCII fallback.
) -- :help 'fillchars'
  -- foldinner: without this, a line inside an open fold but not itself a
  -- fold-start shows the numeric fold level instead of blank, when
  -- foldcolumn is too narrow to draw one symbol per nesting level.

-- Splits (open where the eye expects) --------------------------------------------
opt.splitright = true        -- vertical splits open to the right. :help 'splitright'
opt.splitbelow = true        -- horizontal splits open below. :help 'splitbelow'

-- Files & undo -------------------------------------------------------------------
opt.autoread = true          -- reload a buffer if its file changed on disk and the
                             -- buffer has no unsaved changes. :help 'autoread'
opt.swapfile = false         -- no .swp files (matches old config). :help 'swapfile'
opt.undofile = true          -- persist undo history across sessions to disk. :help 'undofile'
opt.confirm = true           -- on :q with unsaved changes, prompt instead of hard-erroring.
                             -- :help 'confirm'  (still prevents accidental data loss —
                             -- it asks, it never silently discards.)

-- Behaviour ----------------------------------------------------------------------
opt.mouse = 'a'              -- mouse enabled in all modes. :help 'mouse'
opt.clipboard = 'unnamedplus'-- use the OS clipboard for yank/paste. :help 'clipboard'
                             -- (Scheduled after startup by kickstart to avoid slowing
                             --  launch; here we set it directly — fine on a desktop.)
opt.updatetime = 250         -- faster CursorHold (used by diagnostics/git). :help 'updatetime'
opt.timeoutlen = 300         -- ms to wait for a mapped sequence (which-key hints). :help 'timeoutlen'
opt.breakindent = true       -- wrapped lines keep their indent (readability). :help 'breakindent'

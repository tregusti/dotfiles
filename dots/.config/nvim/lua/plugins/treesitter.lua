-- Treesitter: real syntax parsing for highlighting and indentation.
--
-- Treesitter builds a concrete syntax tree per buffer, so highlighting understands
-- structure (a function name vs a string vs a comment) rather than matching regexes.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter
--
-- The plugin itself only installs parsers; it doesn't wire up highlighting/indent,
-- so we do that ourselves in a FileType autocmd below. :help nvim-treesitter
--
-- `parsers` covers the confirmed Tier-1 languages, installed on first launch.
-- `filetypes` is the (mostly overlapping) list of actual Neovim filetypes to start
-- Treesitter on — some parsers above are injection-only (jsdoc, markdown_inline,
-- luadoc) and have no filetype of their own.

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,        -- required: this plugin does not support lazy-loading.
  build = ':TSUpdate', -- compile/update parsers after install.
  config = function()
    local parsers = {
      -- Web / React stack
      'javascript', 'typescript', 'tsx', 'jsdoc',
      'html', 'css', 'vue',
      -- Data / docs (jsonc has no separate parser — Neovim maps it to json)
      'json', 'yaml', 'markdown', 'markdown_inline',
      -- Systems / config / this config itself
      'rust', 'lua', 'luadoc', 'bash', 'vim', 'vimdoc',
      'git_config', 'gitcommit', 'diff',
    }
    require('nvim-treesitter').install(parsers)

    local filetypes = {
      'javascript', 'typescript', 'typescriptreact',
      'html', 'css', 'vue',
      'json', 'jsonc', 'yaml', 'markdown',
      'rust', 'lua', 'sh', 'bash', 'vim', 'help',
      'gitconfig', 'gitcommit', 'diff',
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start() -- highlighting. :help treesitter-highlight
        -- Treesitter-based '=' indentation; upstream still calls this experimental.
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- Folds from the same parse tree driving highlighting/indent above.
        -- foldmethod/foldexpr are window-scoped but the parser is buffer-scoped,
        -- so setting them per-FileType (not once globally) is what makes this
        -- reliable. :help 'foldexpr' , neovim/neovim discussion #34246
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- Treesitter's fold query has no comment capture, so multi-line JSDoc
        -- blocks and `// #region` markers never fold under this alone. If that
        -- starts to matter, vim.lsp.foldexpr() folds both (verified live on
        -- ts_ls) but has no fallback for servers/filetypes without
        -- foldingRange support — nvim-ufo (kevinhwang91/nvim-ufo) is what adds
        -- a provider fallback chain (LSP preferred, treesitter fallback) plus
        -- fold preview. Not installed; revisit only if this gap is felt.
      end,
    })
  end,
}

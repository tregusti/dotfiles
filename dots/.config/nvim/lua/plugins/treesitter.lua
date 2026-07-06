-- Treesitter: real syntax parsing for highlighting and indentation.
--
-- Treesitter builds a concrete syntax tree per buffer, so highlighting understands
-- structure (a function name vs a string vs a comment) rather than matching regexes.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter
--
-- `ensure_installed` covers the confirmed Tier-1 languages. Parsers are compiled on
-- first launch. Add a language later by appending its parser name here.

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',                -- the stable API used below. The default branch is
                                    -- a rewrite with a different API; pin master until
                                    -- we deliberately migrate. :help nvim-treesitter
  build = ':TSUpdate',              -- compile/update parsers after install.
  main = 'nvim-treesitter.configs', -- use the .configs module for setup(). :help nvim-treesitter
  opts = {
    ensure_installed = {
      -- Web / React stack
      'javascript', 'typescript', 'tsx', 'jsdoc',
      'html', 'css', 'vue',
      -- Data / docs
      'json', 'jsonc', 'yaml', 'markdown', 'markdown_inline',
      -- Systems / config / this config itself
      'rust', 'lua', 'luadoc', 'bash', 'vim', 'vimdoc',
      'git_config', 'gitcommit', 'diff',
    },
    auto_install = true,   -- install a missing parser when you open that filetype.
    highlight = {
      enable = true,
      -- Some languages still lean on Vim's regex highlighting in places; leave the
      -- door open per-language if needed. :help nvim-treesitter-highlight-mod
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },  -- Treesitter-based '=' indentation. :help nvim-treesitter-indentation
  },
}

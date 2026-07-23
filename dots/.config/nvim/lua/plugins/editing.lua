-- Small editing enhancements, via mini.nvim modules.
--
-- These replace old-config plugins with maintained equivalents.
-- Note what's NOT here because Neovim now ships it:
--   * Commenting: built-in since 0.10 — `gcc` (line), `gc` (motion/visual). No plugin.
--     :help commenting
--   * EditorConfig: built-in — a project's .editorconfig is respected automatically.
--     :help editorconfig
--
-- mini.nvim docs: https://github.com/echasnovski/mini.nvim

return {
  {
    'echasnovski/mini.surround',   -- add/change/delete surrounding quotes/brackets/tags.
    version = '*',                 -- replaces the old tpope/vim-surround.
    opts = {},                     -- default mappings: sa (add), sd (delete), sr (replace).
                                   -- :help MiniSurround
  },
  {
    'echasnovski/mini.ai',         -- smarter text objects (e.g. `va)`, `ci"`, function args).
    version = '*',
    opts = {},                     -- :help MiniAi
  },
  {
    'echasnovski/mini.pairs',      -- auto-close brackets/quotes as you type.
    version = '*',
    opts = {},                     -- :help MiniPairs
  },
}

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
    -- Add/change/delete surrounding quotes/brackets/tags. Replaces the old
    -- tpope/vim-surround. Default mappings: sa (add), sd (delete), sr (replace).
    -- :help MiniSurround
    'echasnovski/mini.surround',
    version = '*',
    opts = {},
  },
  {
    -- Smarter text objects (e.g. `va)`, `ci"`, function args). :help MiniAi
    'echasnovski/mini.ai',
    version = '*',
    opts = {},
  },
  {
    -- Auto-close brackets/quotes as you type. :help MiniPairs
    'echasnovski/mini.pairs',
    version = '*',
    opts = {},
  },
}

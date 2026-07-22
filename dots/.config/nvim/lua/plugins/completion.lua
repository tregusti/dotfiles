-- Autocompletion: blink.cmp.
--
-- Swapped from nvim-cmp (see git history) after a grilling session: blink.cmp
-- bundles LSP/path/buffer/snippet sources natively instead of composing them
-- from separate source plugins, and uses Neovim's built-in `vim.snippet` for
-- snippet expansion instead of a separate engine (LuaSnip). No inline/"ghost
-- text" completion is enabled (matches the decision to avoid live completion,
-- and is blink's own default); the menu only appears on demand.
--
-- Docs: https://cmp.saghen.dev

return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '1.*',
  opts = {
    completion = {
      -- Highlight the first item but never insert it just by navigating.
      -- :help ins-completion (mirrors the old completeopt=noinsert intent)
      list = { selection = { auto_insert = false } },
    },
    -- Explicit, discoverable keys (no auto-select, no ghost text).
    -- https://cmp.saghen.dev/configuration/keymap
    keymap = {
      preset = 'none',
      ['<C-n>'] = { 'select_next', 'fallback' },       -- next item
      ['<C-p>'] = { 'select_prev', 'fallback' },       -- previous item
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },   -- scroll docs up
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' }, -- scroll docs down
      ['<C-y>'] = { 'select_and_accept', 'fallback' }, -- accept
      ['<C-space>'] = { 'show' },                      -- manually trigger the menu
      -- Jump through snippet placeholders (native vim.snippet, no LuaSnip).
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        -- Neovim Lua API completions (this config's own files), given priority
        -- over lua_ls's generic completions via score_offset.
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        -- VS Code-format snippets under ~/.config/nvim/snippets (see
        -- code-snippets/ at the repo root, symlinked in). Moderate ranking
        -- boost: usually wins over LSP matches without permanently burying
        -- them when a trigger prefix overlaps a real identifier/keyword.
        snippets = {
          opts = { friendly_snippets = false },
          score_offset = 50,
        },
      },
    },
  },
}

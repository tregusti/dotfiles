-- Autocompletion: nvim-cmp + LuaSnip.
--
-- PROVISIONAL (low-fluency, but not yet formally chosen): nvim-cmp is the
-- kickstart default and the most-documented completion engine. The alternative is
-- blink.cmp (newer, faster). Revisit if desired — this is a clean swap. No inline/
-- "ghost text" completion is enabled (matches the decision to avoid live completion);
-- the menu only appears on demand.
--
-- Docs: https://github.com/hrsh7th/nvim-cmp , https://github.com/L3MON4D3/LuaSnip

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',                 -- snippet engine (replaces the old UltiSnips).
      build = (function()
        -- Optional regex support for some snippets; skip on Windows.
        if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'saadparwaiz1/cmp_luasnip',           -- LuaSnip source for cmp.
    'hrsh7th/cmp-nvim-lsp',               -- LSP completions.
    'hrsh7th/cmp-path',                   -- filesystem path completions.
    'hrsh7th/cmp-buffer',                 -- words from open buffers.
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' }, -- :help completeopt
      -- Explicit, discoverable keys (no auto-select, no ghost text). :help cmp-mapping
      mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),  -- next item
        ['<C-p>'] = cmp.mapping.select_prev_item(),  -- previous item
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),     -- scroll docs up
        ['<C-f>'] = cmp.mapping.scroll_docs(4),      -- scroll docs down
        ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- accept
        ['<C-Space>'] = cmp.mapping.complete({}),    -- manually trigger the menu
        -- Jump through snippet placeholders.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'lazydev', group_index = 0 }, -- Lua API completions (see below), before LSP.
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
      },
    })
  end,
}

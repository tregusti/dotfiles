-- lazydev.nvim: makes editing THIS Neovim config pleasant.
--
-- It configures lua_ls with the Neovim runtime API and plugin types, so `vim.*`
-- and plugin modules autocomplete and don't show as "undefined". Registers a cmp
-- completion source named "lazydev" (referenced in completion.lua).
--
-- Docs: https://github.com/folke/lazydev.nvim

return {
  'folke/lazydev.nvim',
  ft = 'lua', -- only load when editing Lua files.
  opts = {
    library = {
      -- Load the Neovim types when the `vim.uv` word is found (i.e. real config).
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}

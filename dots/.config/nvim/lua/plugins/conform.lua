-- Formatting: conform.nvim.
--
-- One uniform interface to run a formatter per filetype, honoring each project's
-- own formatter config (a repo's .prettierrc, etc.). Formatters are installed via
-- mason (see lsp.lua's ensure_installed).
--
-- Docs: https://github.com/stevearc/conform.nvim
--
-- PROVISIONAL: format-on-save is ON below. If it ever fights a project's own setup,
-- flip `format_on_save` off and format manually with <leader>f. Prettier is used for
-- the web stack because it respects the project's config; ESLint's own --fix is
-- handled separately by the eslint LSP.

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Manual format (works even if format-on-save is disabled). PROVISIONAL key.
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    -- Format on save, but fall back to the LSP formatter if no CLI formatter is set,
    -- and don't block for slow ones. :help conform.format
    format_on_save = function(bufnr)
      -- Some languages (e.g. via LSP) have no reliable CLI formatter — let the LSP
      -- handle those. Prettier/stylua/shfmt cover the rest.
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      sh = { 'shfmt' },
      -- prettierd handles the whole web stack; conform picks the first available.
      javascript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      vue = { 'prettierd' },
      css = { 'prettierd' },
      html = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' },
      -- Rust is formatted by rust_analyzer via the LSP fallback (rustfmt).
    },
  },
}

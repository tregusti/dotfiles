-- Formatting: conform.nvim.
--
-- One uniform interface to run a formatter per filetype, honoring each project's
-- own formatter config (a repo's .prettierrc, etc.). Formatters are installed via
-- mason (see lsp.lua's ensure_installed).
--
-- Docs: https://github.com/stevearc/conform.nvim
--
-- Model (mirrors VS Code): format-on-save is enabled globally, but for the web
-- stack a formatter only *activates* when the project carries its config file
-- (`require_cwd`, conform's equivalent of VS Code's prettier.requireConfig).
-- The project's config file both selects the tool (oxfmt vs prettier) and sets
-- its options; no editor files needed in projects. A project with neither
-- config is left alone. Single-formatter ecosystems (lua/rust/sh) always
-- format. ESLint's own --fix is handled separately by the eslint LSP.

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
    -- Format every buffer on save. Give the formatter at most 1000ms.
    -- lsp_format = 'fallback' means: when formatters_by_ft below lists no CLI
    -- formatter for the filetype, ask the buffer's LSP server to format instead.
    -- Rust relies on this fallback, because rust_analyzer formats by running
    -- rustfmt internally. See :help conform.format for both options.
    format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },

    -- Per-formatter overrides.
    -- require_cwd = true marks a formatter as unavailable unless its own config
    -- file is found upward from the file being saved. The file names each
    -- formatter searches for are listed next to it. A project with no such
    -- config file gets no formatting from that formatter. When a project has
    -- oxfmt installed locally, the binary in node_modules/.bin is used.
    formatters = {
      oxfmt = { require_cwd = true }, -- .oxfmtrc.json(c) / oxfmt.config.ts
      prettierd = { require_cwd = true }, -- .prettierrc* / prettier key in package.json
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      sh = { 'shfmt' },
      toml = { 'oxfmt' },
      -- Rust is formatted by rust_analyzer via the LSP fallback (rustfmt).

      -- Web stack: the project's config file picks the tool; oxfmt wins if both exist.
      javascript = { 'oxfmt', 'prettierd', stop_after_first = true },
      javascriptreact = { 'oxfmt', 'prettierd', stop_after_first = true },
      typescript = { 'oxfmt', 'prettierd', stop_after_first = true },
      typescriptreact = { 'oxfmt', 'prettierd', stop_after_first = true },
      vue = { 'oxfmt', 'prettierd', stop_after_first = true },
      css = { 'oxfmt', 'prettierd', stop_after_first = true },
      html = { 'oxfmt', 'prettierd', stop_after_first = true },
      json = { 'oxfmt', 'prettierd', stop_after_first = true },
      jsonc = { 'oxfmt', 'prettierd', stop_after_first = true },
      yaml = { 'oxfmt', 'prettierd', stop_after_first = true },
      markdown = { 'oxfmt', 'prettierd', stop_after_first = true },
    },
  },
}

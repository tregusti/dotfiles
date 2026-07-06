-- Linting: oxlint (via nvim-lint), config-gated per project.
--
-- Why separate from ESLint: ESLint runs as a language server (see lsp.lua). oxlint
-- is a fast Rust-based linter run as a CLI on demand. Both were requested; both are
-- gated on the project actually using them.
--
-- This runs oxlint ONLY when the project has an oxlint config (.oxlintrc.json), so
-- it stays silent on projects that don't use it. The oxlint binary is installed via
-- mason (see lsp.lua ensure_installed).
--
-- Docs: nvim-lint https://github.com/mfussenegger/nvim-lint , oxlint https://oxc.rs/docs/guide/usage/linter
--
-- KNOWN FIRST-RUN GOTCHA (second of two): if nvim-lint's bundled oxlint spec is
-- missing or its output format has drifted, diagnostics won't appear. This is the
-- other area to verify on first launch; see README.

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    -- Attach oxlint to the JS/TS/Vue family. nvim-lint ships an `oxlint` spec.
    lint.linters_by_ft = {
      javascript = { 'oxlint' },
      javascriptreact = { 'oxlint' },
      typescript = { 'oxlint' },
      typescriptreact = { 'oxlint' },
      vue = { 'oxlint' },
    }

    -- Only lint when an oxlint config exists somewhere at/above the file. This is
    -- the per-project gate. :help vim.fs.find
    local function has_oxlint_config(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == '' then
        return false -- unnamed/scratch buffer: nothing to resolve a project root from.
      end
      local found = vim.fs.find(
        { '.oxlintrc.json', 'oxlint.json' },
        { upward = true, path = name, stop = vim.uv.os_homedir() }
      )
      return #found > 0
    end

    local group = vim.api.nvim_create_augroup('oxlint-on-save', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = group,
      callback = function(args)
        if has_oxlint_config(args.buf) then
          lint.try_lint()
        end
      end,
    })
  end,
}

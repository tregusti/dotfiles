-- LSP: language servers for completion, diagnostics, go-to-definition, rename, etc.
--
-- Mental model (see docs/adr/): LSP is a protocol for tools that feed the editor
-- diagnostics/actions — not just "languages". A language's type-checker and a linter
-- can each be a separate server. Servers attach per-project by finding a root marker
-- (package.json, tsconfig.json, Cargo.toml, .git), and honor that project's own
-- config files. Nothing here imposes global rules.
--
-- Pattern (Neovim 0.11+ native API): mason installs the server binaries;
-- nvim-lspconfig ships each server's base config as a `lsp/<name>.lua` on the
-- runtimepath; we override per-server with `vim.lsp.config()` and activate with
-- `vim.lsp.enable()`. The old `require('lspconfig').x.setup{}` framework is
-- deprecated and intentionally not used. Docs:
--   mason:      https://github.com/williamboman/mason.nvim
--   lspconfig:  https://github.com/neovim/nvim-lspconfig
--   native API: `:help vim.lsp.config` , `:help vim.lsp.enable`
--   server list & options: `:help lspconfig-all`
--
-- Confirmed languages: TS/JS/JSX/TSX, Vue, Rust, HTML/CSS(+Tailwind), JSON, Markdown,
-- Lua, Bash. Diagnostics layer: ESLint here (as an LSP), oxlint in linting.lua.
--
-- KNOWN FIRST-RUN GOTCHA: the Vue + TypeScript "hybrid mode" wiring (ts_ls loading
-- the @vue/typescript-plugin from the mason-installed vue-language-server) is the
-- most version-sensitive part. If Vue files misbehave, check the vue_ls README.

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },     -- installer for servers/tools.
    'williamboman/mason-lspconfig.nvim',          -- name-maps mason <-> lspconfig.
    'WhoIsSethDaniel/mason-tool-installer.nvim',  -- ensure_installed for tools.
    { 'j-hui/fidget.nvim', opts = {} },           -- small LSP progress UI (bottom-right).
    'hrsh7th/cmp-nvim-lsp',                        -- advertise nvim-cmp completion capabilities.
  },
  config = function()
    -- Keymaps get attached per-buffer only once a server attaches to it.
    -- PROVISIONAL bindings (kickstart's g* / <leader>* scheme) — revisit after
    -- /teach vim. :help LspAttach , :help vim.lsp.buf
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        local builtin = require('telescope.builtin')
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, 'Code [A]ction')
        map('grr', builtin.lsp_references, 'Goto [R]eferences')
        map('grd', builtin.lsp_definitions, 'Goto [D]efinition')
        map('gri', builtin.lsp_implementations, 'Goto [I]mplementation')
        map('grt', builtin.lsp_type_definitions, 'Goto [T]ype definition')
        map('gO', builtin.lsp_document_symbols, 'Document [S]ymbols')
        map('K', vim.lsp.buf.hover, 'Hover documentation')
      end,
    })

    -- Advertise the extra completion capabilities nvim-cmp provides so servers
    -- send richer results (snippets, etc.). Applied to all servers via the '*'
    -- config below. :help vim.lsp.config
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Path to the mason-installed Vue language server, needed by ts_ls (hybrid mode).
    local vue_ls_path = vim.fn.stdpath('data')
      .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    local vue_plugin = {
      name = '@vue/typescript-plugin',
      location = vue_ls_path,
      languages = { 'vue' },
      configNamespace = 'typescript',
    }

    -- Per-server overrides. `{}` means "use lspconfig defaults". :help lspconfig-all
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            -- Silence "undefined global vim" when editing this config. :help lua_ls
            diagnostics = { globals = { 'vim' } },
          },
        },
      },
      rust_analyzer = {},                       -- Rust. :help lspconfig-all rust_analyzer
      ts_ls = {                                 -- TypeScript/JavaScript/JSX/TSX (+Vue script).
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
        init_options = { plugins = { vue_plugin } },
      },
      vue_ls = {},                              -- Vue templates (Volar). Hybrid mode with ts_ls.
      html = {},
      cssls = {},
      tailwindcss = {},                         -- class completion in JSX/HTML/Vue when a
                                                -- tailwind config exists in the project.
      jsonls = {},
      bashls = {},
      marksman = {},                            -- Markdown.
      eslint = {                                -- Lint diagnostics + fix-on-... via LSP.
        -- Only active when the project has an ESLint config (config-gated by design).
        settings = { workingDirectories = { mode = 'auto' } },
      },
    }

    -- Tools mason should keep installed: all servers above, plus formatters
    -- (used by conform.lua) and the oxlint binary (used by linting.lua).
    require('mason-tool-installer').setup({
      ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
        'stylua',       -- Lua formatter
        'prettierd',    -- JS/TS/CSS/HTML/JSON/Markdown/Vue formatter (fast daemon)
        'shfmt',        -- shell formatter
        'oxlint',       -- fast linter (see linting.lua)
      }),
    })

    -- mason-lspconfig is present so mason-tool-installer can map lspconfig server
    -- names to mason package names. We don't use its auto-enable — we enable
    -- servers ourselves below.
    require('mason-lspconfig').setup({
      ensure_installed = {},    -- handled by mason-tool-installer above.
      automatic_enable = false, -- we call vim.lsp.enable() ourselves.
    })

    -- Native LSP config (Neovim 0.11+). '*' applies to every server; per-server
    -- tables merge on top of nvim-lspconfig's shipped defaults. :help vim.lsp.config
    vim.lsp.config('*', { capabilities = capabilities })
    for name, cfg in pairs(servers) do
      vim.lsp.config(name, cfg)
    end

    -- Activate the servers; each attaches to matching buffers once its root is found.
    -- :help vim.lsp.enable
    vim.lsp.enable(vim.tbl_keys(servers))
  end,
}

-- Toggleable UI state, built on Snacks.toggle so they get which-key's
-- enabled/disabled icon and a toggle notification for free. These must live
-- in a plugin spec's `config` (not config/keymaps.lua) because keymaps.lua
-- loads before lazy.nvim sets up plugins — `require('snacks')` isn't
-- resolvable that early. :help lazy.nvim-🔌-plugin-spec
-- Docs: https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md
return {
  'folke/snacks.nvim',
  config = function()
    -- <leader>u is the [U]I group (which-key.lua).
    require('snacks').toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')

    -- Loclist is window-local, so populate it with the current window's
    -- diagnostics before checking/opening it. Kept out of <leader>q
    -- (quit/session group, session.lua), matching LazyVim's convention.
    -- :help vim.diagnostic.setloclist
    require('snacks').toggle
      .new({
        name = 'Location List',
        get = function()
          return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
        end,
        set = function(state)
          if state then
            vim.diagnostic.setloclist()
          else
            vim.cmd('lclose')
          end
        end,
      })
      :map('<leader>xl')

    -- :help :copen :help :cclose
    require('snacks').toggle
      .new({
        name = 'Quickfix List',
        get = function()
          return vim.fn.getqflist({ winid = 0 }).winid ~= 0
        end,
        set = function(state)
          vim.cmd(state and 'copen' or 'cclose')
        end,
      })
      :map('<leader>xq')
  end,
}

-- Centered floating cmdline (`:`), built on Neovim's native (experimental) ui2
-- layer rather than replacing the UI wholesale like noice.nvim used to.
--
-- Docs: https://github.com/rachartier/tiny-cmdline.nvim

return {
  'rachartier/tiny-cmdline.nvim',
  init = function()
    -- Required by ui2's floating cmdline; without this it still renders on
    -- the last line. :help 'cmdheight'
    vim.o.cmdheight = 0
    -- ui2 is opt-in and experimental as of Neovim 0.12.
    require('vim._core.ui2').enable({})
  end,
  opts = {}, -- defaults already center at x=50%, y=50%
}

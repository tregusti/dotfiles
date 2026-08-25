-- In-buffer markdown rendering (headings, code blocks, tables, etc).
-- Docs: https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {},
  keys = {
    {
      '<leader>um',
      function()
        require('render-markdown').toggle()
      end,
      desc = 'Toggle [M]arkdown rendering',
    },
  },
}

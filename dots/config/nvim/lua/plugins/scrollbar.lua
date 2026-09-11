-- Config based on:
-- https://github.com/petertriho/nvim-scrollbar/issues/112#issuecomment-2811527635

return {
  'petertriho/nvim-scrollbar',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'kevinhwang91/nvim-hlslens',
  },
  opts = {
    handlers = {
      gitsigns = true,
      search = true,
    },
  },
}

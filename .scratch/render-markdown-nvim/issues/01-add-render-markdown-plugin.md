Status: needs-triage

# Add MeanderingProgrammer/render-markdown.nvim

Add the `MeanderingProgrammer/render-markdown.nvim` plugin to the Neovim config
for in-buffer markdown rendering, bound behind `<leader>um` (the `[U]I` group,
per `which-key.lua`) as a toggle.

## Notes

- Repo: https://github.com/MeanderingProgrammer/render-markdown.nvim
- `<leader>u` is already reserved as the `[U]I` group in
  `dots/.config/nvim/lua/plugins/which-key.lua` — `um` should read as
  toggle-[M]arkdown-rendering.
- New plugin file would live at `dots/.config/nvim/lua/plugins/`, following
  the pattern in `explorer.lua` (own file per plugin, `keys` table for
  mappings).
- Check plugin's required dependencies (nvim-treesitter, nvim-web-devicons)
  are already present before wiring it in.

Status: needs-triage

# Find ways to manually reflow comments (e.g. in Lua)

Investigate how to manually reflow a wrapped comment block — e.g. a multi-line
`--` comment in a `.lua` file — so editing a word mid-paragraph re-wraps the
surrounding lines to `textwidth`, with the `--` leader correctly re-added to
each continuation line, the way `gqip` reflows a plain prose paragraph.

## Notes

- No `'formatoptions'` or `'comments'` configuration currently exists anywhere
  in `dots/.config/nvim/` (checked `lua/config/options.lua` and for any
  `ftplugin/` directory — neither sets these). This is native, unconfigured
  Vim territory, not a plugin gap.
- Vim's own mechanism for this is `gq{motion}`/`gw{motion}` combined with
  `'formatoptions'` containing `c` (auto-wrap comments, inserting the leader)
  and the `'comments'` option (defines what counts as a comment leader per
  filetype, e.g. `://` vs `:--` vs `:#`). Confirm what Neovim's Lua
  filetype/treesitter ships as defaults before adding anything — may already
  be closer to working than assumed.
- Worth checking whether `formatoptions`/`comments` should be set globally
  vs. per-filetype (`autocmd FileType`), consistent with how `treesitter.lua`
  already sets `indentexpr`/fold options per-`FileType` rather than globally.
- Scope: at minimum Lua (this repo's own config is almost entirely Lua).
  Worth checking whether the same setup transfers to other comment styles
  (`//`, `#`) used elsewhere in this repo, or needs per-filetype tuning.
- Related teaching context: `teach/nvim/` is mid-way through a Neovim
  refresher curriculum; this could become a lesson there once resolved,
  same pattern as recent search/replace and folding decisions — not
  required, just worth knowing that workspace exists if an agent wants
  written material behind the eventual config change.

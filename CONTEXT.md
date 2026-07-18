# Glossary

Terms with a pinned meaning in this repo. Keep definitions implementation-free.

## Formatting

**Candidate list** — the global, per-language list of formatters the editor
*may* use (e.g. "markdown: oxfmt, then prettierd"). Lives in the dotfiles.
Never decides what a given project gets; only what is on offer. Equivalent of
VS Code's per-language default-formatter settings.

**Activation** — a project turning a candidate formatter on by carrying that
formatter's own config file (`.prettierrc`, `.oxfmtrc.json`, …). The config
file both selects the tool and sets its options. Projects contain no
editor-specific files. Equivalent of VS Code's `prettier.requireConfig`.

**Contested ecosystem** — a language where multiple formatters compete
(web/markdown: prettier vs oxfmt). Formatting runs only on activation; a
project with no formatter config is left untouched ("we don't know how to
format, so we don't").

**Single-formatter ecosystem** — a language with one blessed formatter and no
real contest (Rust→rustfmt, Lua→stylua, sh→shfmt). Always formatted on save,
with the project's config honored when present, tool defaults otherwise.

**Trigger default** — whether format-on-save is on-by-default (opt-out) or
off-by-default (opt-in). Decided: globally on; contested ecosystems are
effectively opt-in via activation.
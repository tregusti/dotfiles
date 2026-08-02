# Blink snippets: VS Code-style `include` / `exclude`

Research date: 2026-07-31

## Result

`blink.cmp`'s built-in snippets source does **not** implement the per-snippet
`include` and `exclude` file-glob fields supported by VS Code. I found no
upstream Blink issue, pull request, or discussion that specifically requests
that feature.

The closest upstream issue, [#197: Support project-scoped snippets
(`.code-snippets`)](https://github.com/Saghen/blink.cmp/issues/197), is not
about per-snippet filepath rules. It asks for workspace/project `.code-snippets`
files and their language `scope` field. It remains open and is labelled
`backlog`, `feature`, and `sources` (as of this research).

## What VS Code supports

VS Code officially supports optional `include` and `exclude` on an individual
snippet. They accept one glob or an array of globs; filename-only patterns
match a filename, path patterns match the full path, and `exclude` wins if both
match. These fields work in language-specific and global snippet files and can
be combined with `scope`.

Source: [VS Code: Snippets — File pattern
scope](https://code.visualstudio.com/docs/editing/userdefinedsnippets#_file-pattern-scope).

That is separate from VS Code's **project snippet scope**: a
`.vscode/*.code-snippets` file is scoped to a workspace/project. Source:
[VS Code: Snippets — Project snippet
scope](https://code.visualstudio.com/docs/editing/userdefinedsnippets#_project-snippet-scope).

## Pinned Blink behaviour

This repository pins Blink at `78336bc89ee5365633bcf754d93df01678b5c08f`
(`v1.10.2`) in `dots/.config/nvim/lazy-lock.json`; the installed checkout is at
the same commit.

At that commit, Blink's parser passes each object to `read_snippet`, which reads
only `prefix`, `body`, and `description`; unknown fields, including `include`
and `exclude`, are discarded. The completion source caches snippets by
**filetype** and calls `get_snippets_for_ft(filetype)`. It has no current-buffer
path in that loading/filtering path, so it cannot evaluate per-snippet filepath
globs.

Primary sources:

- [`utils.lua` — `read_snippet`](https://github.com/Saghen/blink.cmp/blob/78336bc89ee5365633bcf754d93df01678b5c08f/lua/blink/cmp/sources/snippets/utils.lua)
- [`registry.lua` — lookup by filetype](https://github.com/Saghen/blink.cmp/blob/78336bc89ee5365633bcf754d93df01678b5c08f/lua/blink/cmp/sources/snippets/default/registry.lua)
- [`init.lua` — per-filetype completion cache](https://github.com/Saghen/blink.cmp/blob/78336bc89ee5365633bcf754d93df01678b5c08f/lua/blink/cmp/sources/snippets/default/init.lua)

Blink does provide `filter_snippets`, but it is evaluated once while constructing
the registry and receives the snippet **file's** filetype and path. Its own docs
describe it as filtering which *snippet files* are loaded, not filtering
individual snippets for the current buffer path. It therefore cannot reproduce
VS Code's semantics.

Source: [Blink snippets documentation — `filter_snippets`](https://cmp.saghen.dev/configuration/snippets#friendly-snippets).

## Implication for this repository

The `include` fields in `code-snippets/typescript.json` are honored by VS Code
but ignored by Blink: the test snippets are offered for all TypeScript buffers
in Neovim. The existing `code-snippets/README.md` documents this accurately.

## Upstream tracker search

I searched Blink's public GitHub issues, pull requests, and discussions using
the feature names and related terms (`include`, `exclude`, `glob`, and snippet
file-path filtering). No exact upstream tracker item surfaced. The only closely
named issue is #197 above, and its body explicitly describes project-scoped
`.code-snippets`, not individual snippet `include`/`exclude` fields.

If this gap matters, a new Blink feature request should state that it is asking
for VS Code-compatible, **per-snippet current-buffer filepath glob filtering**
with `exclude` precedence—not project `.code-snippets` discovery—and link the
VS Code file-pattern-scope documentation above.

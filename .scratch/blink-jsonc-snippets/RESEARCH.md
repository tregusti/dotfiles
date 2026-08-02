# JSONC in blink.cmp custom snippets

Researched 2026-07-31 against the locked blink.cmp revision
`78336bc89ee5365633bcf754d93df01678b5c08f`.

## Finding

`blink.cmp`'s built-in `snippets` provider does **not** currently accept JSONC
for custom VS Code-style snippet files. It reads each `.json` file and calls
`vim.json.decode` directly; on an error it logs a notification and returns an
empty table. It has no comment/trailing-comma preprocessing or parser option.
See [`utils.lua` at the locked revision](https://github.com/Saghen/blink.cmp/blob/78336bc89ee5365633bcf754d93df01678b5c08f/lua/blink/cmp/sources/snippets/utils.lua#L8-L18)
and the [registry call site](https://github.com/Saghen/blink.cmp/blob/78336bc89ee5365633bcf754d93df01678b5c08f/lua/blink/cmp/sources/snippets/default/registry.lua#L63-L72).

This differs from VS Code: its official documentation says snippet files are
JSON and support C-style comments. [VS Code: user-defined snippets](https://code.visualstudio.com/docs/editing/userdefinedsnippets#_create-your-own-snippets).

The current blink documentation still labels its custom-snippet examples
`jsonc`, while saying that only VS Code-style snippets are supported. That is
syntax-highlighting/documentation, not evidence of a JSONC parser, and is
inconsistent with the locked source above. [Blink snippets documentation](https://cmp.saghen.dev/configuration/snippets#custom-snippets).

## Relevant upstream issues

1. [#132 — Snippet, Buffer Sources Not Being Loaded](https://github.com/Saghen/blink.cmp/issues/132)
   is the closest issue. A user reported local VS Code-format snippets not
   loading. The follow-up change, [`c5146a5`](https://github.com/Saghen/blink.cmp/commit/c5146a5),
   was titled “notify user on json parsing error for snippets” and closes #132.
   It improves diagnosis of malformed/JSONC files; it does not add JSONC
   parsing.

2. [#197 — Support project-scoped snippets (`.code-snippets`)](https://github.com/Saghen/blink.cmp/issues/197)
   is open and labelled backlog/feature/sources. It concerns VS Code project
   scope and `scope`, not comments, trailing commas, or JSONC parsing. It is
   therefore not a fix for this problem.

No issue, pull request, or discussion explicitly requesting JSONC support in
the built-in provider was found in the upstream GitHub repository search as of
the research date. This is a negative search result, not an upstream statement
that the feature will not be accepted.

## Practical options

- **Recommended for the shared VS Code + Neovim directory:** keep snippets as
  strict JSON—no comments or trailing commas. Strict JSON remains valid for
  VS Code, so one file works in both consumers.
- **If comments are essential:** open a focused blink.cmp feature request
  referencing the parser call above and the VS Code documentation. The desired
  change is JSONC preprocessing/parsing in both `package.json` and individual
  snippet-file load paths; changing only one would leave the other broken.
- **Local fork/custom source:** replace the built-in loader with a JSONC-aware
  parser. This carries ongoing maintenance cost, and the public built-in-source
  configuration exposes paths and filtering rather than a parser callback.
  [Blink snippet configuration](https://cmp.saghen.dev/configuration/snippets).

## Repository impact

The existing [`code-snippets/README.md`](../../code-snippets/README.md)
recommendation—strict JSON for the shared source of truth—is correct. The
failure is deliberately non-fatal: malformed files disappear from the snippet
provider while other completion providers can keep the completion menu alive,
so check `:messages`/blink notifications when snippets seem absent.

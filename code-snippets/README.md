# code-snippets

Shared VS Code-format snippet files, source of truth for both VS Code and
Neovim (`blink.cmp`'s built-in snippets provider reads this same format).

## Wiring

- **Neovim**: `dots/.config/nvim/snippets` is an in-repo symlink to `../code-snippets`.
  `blink.cmp` scans `~/.config/nvim/snippets` by default, so no plugin config
  is needed beyond what's already in `completion.lua`.
- **VS Code**: `install.sh` symlinks this whole directory to
  `~/Library/Application Support/Code/User/snippets`.
## Format

Strict JSON only — no comments, no trailing commas. VS Code support JSONC, but blink.cmp only supports JSON.

Each top-level key is a snippet name; its value defines the snippet:

```json
{
  "Print to console": {
    "prefix": "log",
    "body": ["console.log('$1');", "$2"],
    "description": "Log output to console"
  },
  "Test snippet": {
    "prefix": "test",
    "body": "test('$1', () => {\n\t$0\n});",
    "include": ["**/*.test.ts", "*.spec.ts"],
    "exclude": ["**/temp/*.ts"],
    "description": "Insert test block"
  }
}
```

- `prefix` — the trigger text (string or array of strings).
- `body` — the inserted text (string, or array of strings joined with `\n`).
  `$1`, `$2` are tabstops, `$0` is the final cursor position,
  `${1:label}` is a placeholder with default text; matching numbers link
  placeholders together.
- `include`/`exclude` — glob patterns restricting the snippet to matching
  files. VS Code honors this; `blink.cmp` does not (see below) — don't rely on
  it from Neovim.

## Known gap: `include`/`exclude` scoping

VS Code's snippet format supports scoping a snippet to files matching a glob
(`include`/`exclude`, used in `typescript.json` to restrict some snippets to
`*.test.ts`/`*.spec.ts`). `blink.cmp`'s built-in snippet loader only scopes by
filetype, not by path glob — so those snippets are available in all
TypeScript files when triggered from Neovim, not just test files. No open
blink.cmp issue tracks glob-based scoping specifically (issue #197 is a
different feature: project-scoped `.code-snippets` files). Accepted as fine
since completion here is manual-trigger/explicit-accept, not automatic.

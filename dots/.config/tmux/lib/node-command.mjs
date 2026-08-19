// A pane whose command is just "node" is too vague to tell apart at a
// glance — this pulls the actual invocation from its direct child process,
// so e.g. a `pnpm run dev` pane doesn't just read "node".

import { basename } from "node:path";
import { spawnSync } from "node:child_process";

function childArgsByPpid() {
  const result = spawnSync("ps", ["-axo", "pid=,ppid=,args="], {
    encoding: "utf8",
  });
  if (result.status !== 0) return new Map();

  const byPpid = new Map();
  for (const line of result.stdout.split("\n")) {
    const match = line.match(/^\s*(\d+)\s+(\d+)\s+(.+)$/);
    if (!match) continue;
    const [, pid, ppid, args] = match;
    if (!byPpid.has(ppid)) byPpid.set(ppid, []);
    byPpid.get(ppid).push({ pid, args });
  }
  return byPpid;
}

// Shortens a full invocation like "node /path/to/bin/pnpm run dev" down to
// "pnpm run dev" — drop the interpreter, reduce the script path to its
// basename, leave the rest (flags/args) untouched.
function shortenInvocation(args) {
  const [, scriptPath, ...rest] = args.split(" ");
  if (!scriptPath) return args;
  return [basename(scriptPath), ...rest].join(" ");
}

// One batched `ps` call for the whole tree, not one per pane.
export function nodeChildArgs() {
  return childArgsByPpid();
}

export function describeNodePane(pane, childArgs) {
  if (pane.command !== "node") return pane.command;

  const child = (childArgs.get(pane.pid) ?? []).find((c) =>
    c.args.startsWith("node "),
  );
  if (!child) return pane.command;

  return `${pane.command} (${shortenInvocation(child.args)})`;
}

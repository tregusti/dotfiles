// Shared session -> window -> pane data gathering for the tree popups
// (tmux-tree.mjs and tmux-tree-kill.mjs) — one `tmux list-panes -a` call,
// parsed into a Map keyed by session name. Purely data, no rendering.

import { spawnSync } from "node:child_process";

const FIELDS = [
  "#{session_name}",
  "#{session_attached}",
  "#{window_index}",
  "#{window_name}",
  "#{window_active}",
  "#{pane_index}",
  "#{pane_current_command}",
  "#{pane_active}",
  "#{pane_pid}",
].join("\t");

export function paneTree() {
  const result = spawnSync("tmux", ["list-panes", "-a", "-F", FIELDS], {
    encoding: "utf8",
  });
  if (result.status !== 0) return new Map();

  const sessions = new Map();
  for (const line of result.stdout.trim().split("\n").filter(Boolean)) {
    const [
      session,
      attached,
      winIdx,
      winName,
      winActive,
      paneIdx,
      command,
      paneActive,
      pid,
    ] = line.split("\t");
    if (!sessions.has(session)) {
      sessions.set(session, { attached: attached === "1", windows: new Map() });
    }
    const { windows } = sessions.get(session);
    if (!windows.has(winIdx)) {
      windows.set(winIdx, {
        name: winName,
        active: winActive === "1",
        panes: [],
      });
    }
    windows.get(winIdx).panes.push({
      index: paneIdx,
      command,
      active: paneActive === "1",
      pid,
    });
  }
  return sessions;
}

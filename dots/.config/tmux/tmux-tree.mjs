#!/usr/bin/env node
// Full session -> window -> pane hierarchy, fuzzy-pickable, styled like the
// other popups (fzf --ansi --reverse, same color language). Meant to
// replace native `choose-tree` on prefix W once it's good enough — prefix w
// still runs the native tree in parallel until then.

import { describeNodePane, nodeChildArgs } from "./lib/node-command.mjs";
import { paneTree } from "./lib/pane-tree.mjs";
import { paneConnector, windowConnector } from "./lib/tree-render.mjs";
import {
  COLOR,
  classify,
  gotoTarget,
  knownProjects,
  pickFromLines,
} from "./lib/tmux-picker.mjs";

// Session lines reuse the tmux-sessions.mjs color language (green = known project,
// yellow = unmatched) so the two popups read consistently; window/pane
// lines are dim and indented to show the tree, with box-drawing connectors.
// Each row ends with a dim `(kind: notes)` parenthetical — counts and
// current/attached markers, the richer context native choose-tree shows.
function renderTree(sessions) {
  const { active, extra } = classify(
    knownProjects(),
    [...sessions.keys()].map((name) => ({ name })),
  );
  const sessionColor = new Map([
    ...active.map((p) => [p.name, COLOR.green]),
    ...extra.map((s) => [s.name, COLOR.yellow]),
  ]);
  const childArgs = nodeChildArgs();

  const paren = (label, ...notes) =>
    `${COLOR.dim} (${label}${notes.length ? `: ${notes.join(", ")}` : ""})${COLOR.reset}`;

  const lines = [];
  for (const [session, { attached, windows }] of sessions) {
    const color = sessionColor.get(session) ?? "";
    const windowCount = windows.size;
    const sessionNotes = [
      `${windowCount} window${windowCount === 1 ? "" : "s"}`,
    ];
    if (attached) sessionNotes.push(COLOR.reset + "attached" + COLOR.dim);
    lines.push(
      `${color}${session}${COLOR.reset}${paren("session", ...sessionNotes)}\t${session}`,
    );

    const windowEntries = [...windows.entries()];
    windowEntries.forEach(([winIdx, win], wi) => {
      const winTarget = `${session}:${winIdx}`;
      const isLastWindow = wi === windowEntries.length - 1;
      const paneCount = win.panes.length;
      const windowNotes = [`${paneCount} pane${paneCount === 1 ? "" : "s"}`];
      if (win.active) windowNotes.push("current");
      // automatic-rename keeps an unrenamed window's name in sync with its
      // active pane's command, so showing both is redundant unless someone
      // (or tmux-resurrect) has actually pinned a distinct name.
      const activeCommand = win.panes.find((p) => p.active)?.command;
      const winLabel =
        !win.name || win.name === activeCommand
          ? winIdx
          : `${winIdx}:${win.name}`;
      lines.push(
        `${COLOR.dim}  ${windowConnector(isLastWindow)} ${COLOR.reset}${winLabel}${paren("window", ...windowNotes)}\t${winTarget}`,
      );

      win.panes.forEach((pane, pi) => {
        const paneTarget = `${winTarget}.${pane.index}`;
        const isLastPane = pi === win.panes.length - 1;
        const paneNotes = pane.active ? ["current"] : [];
        lines.push(
          `${COLOR.dim}  ${paneConnector(isLastWindow, isLastPane)} ${COLOR.reset}${describeNodePane(pane, childArgs)}${paren("pane", ...paneNotes)}\t${paneTarget}`,
        );
      });
    });
  }
  return lines;
}

function main() {
  const sessions = paneTree();
  if (sessions.size === 0) return;

  const picked = pickFromLines(renderTree(sessions));
  if (!picked) return;

  const [target] = picked;
  gotoTarget(target);
}

main();

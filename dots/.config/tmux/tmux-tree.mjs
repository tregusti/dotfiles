#!/usr/bin/env node
// Full session -> window -> pane hierarchy, fuzzy-pickable, styled like the
// other popups (fzf --ansi --reverse, same color language). Meant to
// replace native `choose-tree` on prefix W once it's good enough — prefix w
// still runs the native tree in parallel until then.

import { spawnSync } from "node:child_process";
import {
  COLOR,
  classify,
  gotoTarget,
  knownProjects,
  pickFromLines,
} from "./lib/tmux-picker.mjs";

const FIELDS = [
  "#{session_name}",
  "#{session_attached}",
  "#{window_index}",
  "#{window_name}",
  "#{window_active}",
  "#{pane_index}",
  "#{pane_current_command}",
  "#{pane_active}",
].join("\t");

function paneTree() {
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
    });
  }
  return sessions;
}

// Session lines reuse the tms.mjs color language (green = known project,
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
      const winBranch = isLastWindow ? "└─" : "├─";
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
        `${COLOR.dim}  ${winBranch} ${COLOR.reset}${winLabel}${paren("window", ...windowNotes)}\t${winTarget}`,
      );

      win.panes.forEach((pane, pi) => {
        const paneTarget = `${winTarget}.${pane.index}`;
        const isLastPane = pi === win.panes.length - 1;
        const trunk = isLastWindow ? " " : "│";
        const paneBranch = isLastPane ? "└─" : "├─";
        const paneNotes = pane.active ? ["current"] : [];
        lines.push(
          `${COLOR.dim}  ${trunk}  ${paneBranch} ${COLOR.reset}${pane.command}${paren("pane", ...paneNotes)}\t${paneTarget}`,
        );
      });
    });
  }
  return lines;
}

function main() {
  const sessions = paneTree();
  if (sessions.size === 0) return;

  const target = pickFromLines(renderTree(sessions));
  if (!target) return;

  gotoTarget(target);
}

main();

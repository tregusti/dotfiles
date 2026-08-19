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
  "#{window_index}",
  "#{window_name}",
  "#{pane_index}",
  "#{pane_current_command}",
].join("\t");

function paneTree() {
  const result = spawnSync("tmux", ["list-panes", "-a", "-F", FIELDS], {
    encoding: "utf8",
  });
  if (result.status !== 0) return new Map();

  const sessions = new Map();
  for (const line of result.stdout.trim().split("\n").filter(Boolean)) {
    const [session, winIdx, winName, paneIdx, command] = line.split("\t");
    if (!sessions.has(session)) sessions.set(session, new Map());
    const windows = sessions.get(session);
    if (!windows.has(winIdx)) windows.set(winIdx, { name: winName, panes: [] });
    windows.get(winIdx).panes.push({ index: paneIdx, command });
  }
  return sessions;
}

// Session lines reuse the tms.mjs color language (green = known project,
// yellow = unmatched) so the two popups read consistently; window/pane
// lines are dim and indented to show the tree, with box-drawing connectors.
// A dim `:session`/`:window`/`:pane` suffix spells out what each row is.
function renderTree(sessions) {
  const { active, extra } = classify(
    knownProjects(),
    [...sessions.keys()].map((name) => ({ name })),
  );
  const sessionColor = new Map([
    ...active.map((p) => [p.name, COLOR.green]),
    ...extra.map((s) => [s.name, COLOR.yellow]),
  ]);

  const kind = (label) => `${COLOR.dim} :${label}${COLOR.reset}`;

  const lines = [];
  for (const [session, windows] of sessions) {
    const color = sessionColor.get(session) ?? "";
    lines.push(`${color}${session}${COLOR.reset}${kind("session")}\t${session}`);

    const windowEntries = [...windows.entries()];
    windowEntries.forEach(([winIdx, win], wi) => {
      const winTarget = `${session}:${winIdx}`;
      const isLastWindow = wi === windowEntries.length - 1;
      const winBranch = isLastWindow ? "└─" : "├─";
      lines.push(
        `${COLOR.dim}  ${winBranch} ${winIdx}:${win.name}${COLOR.reset}${kind("window")}\t${winTarget}`,
      );

      win.panes.forEach((pane, pi) => {
        const paneTarget = `${winTarget}.${pane.index}`;
        const isLastPane = pi === win.panes.length - 1;
        const trunk = isLastWindow ? " " : "│";
        const paneBranch = isLastPane ? "└─" : "├─";
        lines.push(
          `${COLOR.dim}  ${trunk}  ${paneBranch} ${pane.command}${COLOR.reset}${kind("pane")}\t${paneTarget}`,
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

#!/usr/bin/env node
// Danger-flavored sibling of tmux-tree.mjs — same session -> window -> pane
// tree, but selecting a row kills it instead of jumping to it. Deliberately
// styled differently (red popup title, plain names instead of green/yellow
// project coloring, red "locked" tags) so it can't be mistaken for the
// navigation tree on prefix w. Your attached session/window/pane is locked
// — killable only via a parallel (sibling) row.

import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, unlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { describeNodePane, nodeChildArgs } from "./lib/node-command.mjs";
import { paneTree } from "./lib/pane-tree.mjs";
import { paneConnector, windowConnector } from "./lib/tree-render.mjs";
import { COLOR, pickFromLines } from "./lib/tmux-picker.mjs";
import {
  isLockedPane,
  isLockedSession,
  isLockedWindow,
  killCommand,
  quoteForTmuxCommand,
} from "./lib/tree-kill.mjs";

// confirm-before's prompt is client-level UI — firing it from inside this
// popup, right before the popup closes (-E), kills the pane it would have
// rendered on before you can ever see it. So picking and confirming are two
// separate tmux command steps (see tmux.conf's `bind-key k { ... }` block):
// this script stages the chosen action to a file, the popup closes, then a
// second invocation (--confirm) reads it back and fires confirm-before from
// the now-restored real pane.
const PENDING_FILE = join(tmpdir(), "tmux-tree-kill-pending.json");

const paren = (label, ...notes) =>
  `${COLOR.dim} (${label}${notes.length ? `: ${notes.join(", ")}` : ""})${COLOR.reset}`;

const lockedNote = () => `${COLOR.red}locked${COLOR.dim}`;

// Each line's hidden tab-delimited fields are target, type, label, locked —
// enough for main() to act on a selection without recomputing anything.
function renderTree(sessions) {
  const childArgs = nodeChildArgs();
  const lines = [];

  for (const [session, { attached, windows }] of sessions) {
    const sessionLocked = isLockedSession(attached);
    const windowCount = windows.size;
    const sessionNotes = [
      `${windowCount} window${windowCount === 1 ? "" : "s"}`,
    ];
    if (attached) sessionNotes.push(`${COLOR.reset}attached${COLOR.dim}`);
    if (sessionLocked) sessionNotes.push(lockedNote());
    lines.push(
      `${session}${paren("session", ...sessionNotes)}\t${session}\tsession\t${session}\t${sessionLocked ? "1" : ""}`,
    );

    const windowEntries = [...windows.entries()];
    windowEntries.forEach(([winIdx, win], wi) => {
      const winTarget = `${session}:${winIdx}`;
      const isLastWindow = wi === windowEntries.length - 1;
      const windowLocked = isLockedWindow(sessionLocked, win.active);
      const paneCount = win.panes.length;
      const windowNotes = [`${paneCount} pane${paneCount === 1 ? "" : "s"}`];
      if (win.active) windowNotes.push("current");
      if (windowLocked) windowNotes.push(lockedNote());
      const activeCommand = win.panes.find((p) => p.active)?.command;
      const winLabel =
        !win.name || win.name === activeCommand
          ? winIdx
          : `${winIdx}:${win.name}`;
      lines.push(
        `${COLOR.dim}  ${windowConnector(isLastWindow)} ${COLOR.reset}${winLabel}${paren("window", ...windowNotes)}\t${winTarget}\twindow\t${winLabel}\t${windowLocked ? "1" : ""}`,
      );

      win.panes.forEach((pane, pi) => {
        const paneTarget = `${winTarget}.${pane.index}`;
        const isLastPane = pi === win.panes.length - 1;
        const paneLocked = isLockedPane(sessionLocked, win.active, pane.active);
        const paneLabel = describeNodePane(pane, childArgs);
        const paneNotes = [];
        if (pane.active) paneNotes.push("current");
        if (paneLocked) paneNotes.push(lockedNote());
        lines.push(
          `${COLOR.dim}  ${paneConnector(isLastWindow, isLastPane)} ${COLOR.reset}${paneLabel}${paren("pane", ...paneNotes)}\t${paneTarget}\tpane\t${paneLabel}\t${paneLocked ? "1" : ""}`,
        );
      });
    });
  }
  return lines;
}

function pickAndStage() {
  const sessions = paneTree();
  if (sessions.size === 0) return;

  const picked = pickFromLines(renderTree(sessions));
  if (!picked) return;

  const [target, type, label, locked] = picked;
  if (locked === "1") {
    console.log(`\n  Not allowed — that's your attached ${type}.\n`);
    spawnSync("sleep", ["1.2"]);
    return;
  }

  writeFileSync(PENDING_FILE, JSON.stringify({ type, target, label }));
}

function confirmPending() {
  if (!existsSync(PENDING_FILE)) return;
  const { type, target, label } = JSON.parse(readFileSync(PENDING_FILE, "utf8"));
  unlinkSync(PENDING_FILE);

  const prompt = `kill ${type} '${label}'? (y/n)`;
  const [cmd, ...args] = killCommand(type, target);
  const command = [cmd, ...args].map(quoteForTmuxCommand).join(" ");
  spawnSync("tmux", ["confirm-before", "-p", prompt, command], {
    stdio: "inherit",
  });
}

function main() {
  if (process.argv.includes("--confirm")) {
    confirmPending();
    return;
  }
  pickAndStage();
}

main();

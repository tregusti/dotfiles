// Run with: node --test lib/tmux-picker.test.mjs
// Covers the pure functions only — anything that shells out to tmux/fzf
// (pickFromLines, ensureSession, gotoTarget, runningSessions) needs a live
// tmux/fzf to exercise and is left to manual testing.

import assert from "node:assert/strict";
import { test } from "node:test";
import { classify, expandHome, renderLine } from "./tmux-picker.mjs";

test("renderLine appends name/dir as trailing tab fields, unaffected by padding", () => {
  const short = renderLine("", "○", "dotfiles", "/home/dotfiles");
  const [, shortName, shortDir] = short.split("\t");
  assert.equal(shortName, "dotfiles");
  assert.equal(shortDir, "/home/dotfiles");

  // Regression: a name long enough to blow past the pad width used to leak
  // a leading space into dir when it was parsed back out of the display
  // text instead of carried as its own field.
  const long = renderLine(
    "",
    "○",
    "mongoose-temporal-instant",
    "/home/mongoose-temporal-instant",
  );
  const [, longName, longDir] = long.split("\t");
  assert.equal(longName, "mongoose-temporal-instant");
  assert.equal(longDir, "/home/mongoose-temporal-instant");
});

test("classify splits known projects against running sessions", () => {
  const projects = [
    { name: "dotfiles", dir: "/home/dotfiles" },
    { name: "quiet-project", dir: "/home/quiet-project" },
  ];
  const sessions = [
    { name: "dotfiles", dir: "/home/dotfiles" },
    { name: "scratch", dir: "/tmp/scratch" },
  ];

  const { active, inactive, extra } = classify(projects, sessions);
  assert.deepEqual(active, [{ name: "dotfiles", dir: "/home/dotfiles" }]);
  assert.deepEqual(inactive, [
    { name: "quiet-project", dir: "/home/quiet-project" },
  ]);
  assert.deepEqual(extra, [{ name: "scratch", dir: "/tmp/scratch" }]);
});

test("expandHome only expands a leading ~", () => {
  const home = process.env.HOME;
  assert.equal(expandHome("~/code/dotfiles"), `${home}/code/dotfiles`);
  assert.equal(expandHome("/already/absolute"), "/already/absolute");
});

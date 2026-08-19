// Run with: node --test lib/tree-kill.test.mjs
// The lock predicates are the safety-critical fork in tmux-tree-kill.mjs —
// get them wrong and you either can't kill anything, or can kill the
// session/window/pane you're sitting in.

import assert from "node:assert/strict";
import { test } from "node:test";
import {
  isLockedPane,
  isLockedSession,
  isLockedWindow,
  killCommand,
  quoteForTmuxCommand,
} from "./tree-kill.mjs";

test("isLockedSession locks only the attached session", () => {
  assert.equal(isLockedSession(true), true);
  assert.equal(isLockedSession(false), false);
});

test("isLockedWindow locks the active window only within the attached session", () => {
  assert.equal(isLockedWindow(true, true), true);
  // active window, but a different (unattached) session — not locked
  assert.equal(isLockedWindow(false, true), false);
  // attached session, but a sibling (inactive) window — not locked
  assert.equal(isLockedWindow(true, false), false);
});

test("isLockedPane locks the active pane only within the attached session's active window", () => {
  assert.equal(isLockedPane(true, true, true), true);
  // sibling pane in the attached session's active window — killable
  assert.equal(isLockedPane(true, true, false), false);
  // active pane, but in a sibling (inactive) window — killable
  assert.equal(isLockedPane(true, false, true), false);
  // active pane and window, but in an unattached session — killable
  assert.equal(isLockedPane(false, true, true), false);
});

test("killCommand maps each type to the matching tmux kill flag", () => {
  assert.deepEqual(killCommand("session", "foo"), ["kill-session", "-t", "foo"]);
  assert.deepEqual(killCommand("window", "foo:1"), ["kill-window", "-t", "foo:1"]);
  assert.deepEqual(killCommand("pane", "foo:1.2"), ["kill-pane", "-t", "foo:1.2"]);
  assert.throws(() => killCommand("bogus", "foo"));
});

test("quoteForTmuxCommand only quotes args confirm-before's parser would otherwise split", () => {
  assert.equal(quoteForTmuxCommand("foo:1.2"), "foo:1.2");
  assert.equal(quoteForTmuxCommand("my session:1"), '"my session:1"');
  assert.equal(quoteForTmuxCommand('has"quote'), '"has\\"quote"');
});

// Pure logic for tmux-tree-kill.mjs: which tree node counts as "the thing
// you're attached to right now" (locked, unkillable), and how to turn a
// (type, target) pair into the tmux command that kills it. Kept separate
// from rendering so the safety-critical lock rule can be tested without a
// live tmux/fzf.

// Locked = your attached session, and — only inside that session — its
// currently active window, and — only inside that window — its currently
// active pane. A window/pane in a *different* session, or a sibling
// window/pane in the attached session, is never locked.
export function isLockedSession(sessionAttached) {
  return sessionAttached;
}

export function isLockedWindow(sessionAttached, windowActive) {
  return sessionAttached && windowActive;
}

export function isLockedPane(sessionAttached, windowActive, paneActive) {
  return sessionAttached && windowActive && paneActive;
}

export function killCommand(type, target) {
  const flag = { session: "kill-session", window: "kill-window", pane: "kill-pane" }[
    type
  ];
  if (!flag) throw new Error(`unknown kill type: ${type}`);
  return [flag, "-t", target];
}

// confirm-before's final argument is parsed as a tmux command line, so any
// arg with whitespace/quotes needs quoting for that parser — separate from
// (and in addition to) argv quoting for the outer spawnSync call.
export function quoteForTmuxCommand(arg) {
  return /[\s"]/.test(arg) ? `"${arg.replace(/(["\\])/g, "\\$1")}"` : arg;
}

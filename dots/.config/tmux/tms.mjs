#!/usr/bin/env node
// Fuzzy-pick a project directory and create-or-attach a tmux session for it.
// Run directly with node (not via a shell rc) so tmux's display-popup
// doesn't have to bootstrap anything just to get this one command.

import {
  COLOR,
  attachOrSwitch,
  classify,
  ensureSession,
  knownProjects,
  pickWithFzf,
  renderLine,
  runningSessions,
} from "./lib/tmux-picker.mjs";

// - active: known project with a running session, stands out
// - extra: running but outside the known project list
// - inactive: known project, no session — open dot, no color
function renderLines({ active, extra, inactive }) {
  return [
    ...active.map((p) => renderLine(COLOR.green, "●", p.name, p.dir)),
    ...extra.map((s) => renderLine(COLOR.yellow, "●", s.name, s.dir)),
    ...inactive.map((p) => renderLine("", "○", p.name, p.dir)),
  ];
}

function main() {
  const groups = classify(knownProjects(), runningSessions());
  const picked = pickWithFzf(renderLines(groups));
  if (!picked) return;

  ensureSession(picked.name, picked.dir);
  attachOrSwitch(picked.name);
}

main();

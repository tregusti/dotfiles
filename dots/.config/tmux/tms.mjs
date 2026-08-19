#!/usr/bin/env node
// Fuzzy-pick a project directory and create-or-attach a tmux session for it.
// Run directly with node (not via a shell rc) so tmux's display-popup
// doesn't have to bootstrap anything just to get this one command.

import { execFileSync, spawnSync } from "node:child_process";
import { readdirSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const COLOR = {
  black: "\x1b[30m",
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  magenta: "\x1b[35m",
  cyan: "\x1b[36m",
  white: "\x1b[37m",
  dim: "\x1b[2m",
  reset: "\x1b[0m",
};

function expandHome(path) {
  return path.startsWith("~") ? join(homedir(), path.slice(1)) : path;
}

// name:path pairs: dotfiles first, then every directory under
// ~/Dropbox/code/personal (picked up automatically, no hand-maintained list).
function knownProjects() {
  const home = homedir();
  const personalRoot = join(home, "Dropbox/code/personal");
  const projects = [{ name: "dotfiles", dir: join(home, ".dotfiles") }];
  for (const entry of readdirSync(personalRoot, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      projects.push({ name: entry.name, dir: join(personalRoot, entry.name) });
    }
  }
  return projects;
}

function runningSessions() {
  const result = spawnSync(
    "tmux",
    ["list-sessions", "-F", "#S:#{session_path}"],
    { encoding: "utf8" },
  );
  if (result.status !== 0) return [];
  return result.stdout
    .trim()
    .split("\n")
    .filter(Boolean)
    .map((line) => {
      const [name, ...rest] = line.split(":");
      return { name, dir: rest.join(":") };
    });
}

// Running sessions float to the top, in this order: known projects with a
// session, then open sessions with no matching project entry (e.g. attached
// outside the known project dirs, using tmux's own record of their working
// directory), then known projects with no session.
function classify(projects, sessions) {
  const sessionNames = new Set(sessions.map((s) => s.name));
  const projectNames = new Set(projects.map((p) => p.name));
  return {
    active: projects.filter((p) => sessionNames.has(p.name)),
    inactive: projects.filter((p) => !sessionNames.has(p.name)),
    extra: sessions.filter((s) => !projectNames.has(s.name)),
  };
}

// --ansi tells fzf to render the color codes instead of matching/displaying
// them literally.
// - active: active project sesssions, should stand out
// - extra: running but outside the known project list
// - inactive: no color
function renderLines({ active, extra, inactive }) {
  const line = (color, dot, name, dir) => {
    const paddedName = `${dot} ${name}: `.padEnd(19);
    const namepart = `${color}${paddedName}${COLOR.reset}`;
    const pathpart = `${COLOR.dim}${dir}${COLOR.reset}`;
    return `${namepart} ${pathpart}`;
  };
  return [
    ...active.map((p) => line(COLOR.green, "●", p.name, p.dir)),
    ...extra.map((s) => line(COLOR.yellow, "●", s.name, s.dir)),
    ...inactive.map((p) => line("", "○", p.name, p.dir)),
  ];
}

function pickWithFzf(lines) {
  const fzf = spawnSync("fzf", ["--ansi", "--reverse"], {
    input: lines.join("\n") + "\n",
    encoding: "utf8",
  });
  if (fzf.status !== 0 || !fzf.stdout.trim()) return null;

  const selection = fzf.stdout.replace(/\x1b\[[0-9;]*m/g, "").trim();
  const [namepart, dir] = selection.split(": ");
  const name = namepart.replace(/^[●○] /, "");
  return { name, dir };
}

// has-session + plain new-session, not `-A -d`: `-A` only stays detached
// the first time a session is created — on an existing session it silently
// drops `-d` and attaches right here, inside the popup's own pty.
function ensureSession(name, dir) {
  const hasSession =
    spawnSync("tmux", ["has-session", "-t", name]).status === 0;
  if (!hasSession) {
    execFileSync("tmux", [
      "new-session",
      "-d",
      "-s",
      name,
      "-c",
      expandHome(dir),
    ]);
  }
}

function attachOrSwitch(name) {
  if (process.env.TMUX) {
    execFileSync("tmux", ["switch-client", "-t", name], { stdio: "inherit" });
  } else {
    spawnSync("tmux", ["attach", "-t", name], { stdio: "inherit" });
  }
}

function main() {
  const sessions = runningSessions();
  const projects = knownProjects();
  const groups = classify(projects, sessions);
  const lines = renderLines(groups);
  const picked = pickWithFzf(lines);
  if (!picked) return;

  ensureSession(picked.name, picked.dir);
  attachOrSwitch(picked.name);
}

main();

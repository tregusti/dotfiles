// Shared bits for the tmux popup pickers (tms.mjs, tmux-tree.mjs): known
// project discovery, live tmux session state, fzf rendering/picking, and
// session attach/switch. Node stdlib only, no deps.

import { execFileSync, spawnSync } from "node:child_process";
import { readdirSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

export const COLOR = {
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

export function expandHome(path) {
  return path.startsWith("~") ? join(homedir(), path.slice(1)) : path;
}

// name:path pairs: dotfiles first, then every directory under
// ~/Dropbox/code/personal (picked up automatically, no hand-maintained list).
export function knownProjects() {
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

export function runningSessions() {
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

// Splits known projects against live sessions: active (known project with a
// running session), inactive (known project, no session), extra (running
// session with no matching known project — e.g. attached outside the known
// project dirs, using tmux's own record of its working directory).
export function classify(projects, sessions) {
  const sessionNames = new Set(sessions.map((s) => s.name));
  const projectNames = new Set(projects.map((p) => p.name));
  return {
    active: projects.filter((p) => sessionNames.has(p.name)),
    inactive: projects.filter((p) => !sessionNames.has(p.name)),
    extra: sessions.filter((s) => !projectNames.has(s.name)),
  };
}

// namepart is padded to `width` before color codes are added, so the ANSI
// escapes (invisible on screen) don't get counted against the padding.
// name/dir are also appended as hidden tab-delimited fields (see
// pickFromLines) so picking a line back out never depends on parsing the
// display text — long names that blow past `width` won't corrupt dir.
export function renderLine(color, dot, name, dir, width = 19) {
  const paddedName = `${dot} ${name}: `.padEnd(width);
  const namepart = `${color}${paddedName}${COLOR.reset}`;
  const pathpart = `${COLOR.dim}${dir}${COLOR.reset}`;
  return `${namepart} ${pathpart}\t${name}\t${dir}`;
}

// Lines carry hidden tab-delimited fields after the display column —
// `${display}\t${field1}\t${field2}...` — so a line can show one thing
// (padded/colored text, indented tree text) while selecting it returns
// exact values (a project name + dir, a precise tmux target like
// "session:2.1") unaffected by padding or display formatting. fzf only
// shows/searches the first column.
export function pickFromLines(lines) {
  const fzf = spawnSync(
    "fzf",
    ["--ansi", "--reverse", "--delimiter", "\t", "--with-nth=1"],
    { input: lines.join("\n") + "\n", encoding: "utf8" },
  );
  if (fzf.status !== 0 || !fzf.stdout.trim()) return null;

  const [, ...fields] = fzf.stdout.trim().split("\t");
  return fields;
}

// Switches (or attaches, outside tmux) to a target that may be a bare
// session, "session:window", or "session:window.pane" — narrowing down
// session -> window -> pane so it works regardless of which level a tree
// picker's selection resolved to.
export function gotoTarget(target) {
  const [sessionPart, rest] = target.split(":");
  const inTmux = Boolean(process.env.TMUX);

  if (inTmux) {
    execFileSync("tmux", ["switch-client", "-t", sessionPart], {
      stdio: "inherit",
    });
  } else {
    spawnSync("tmux", ["attach", "-t", sessionPart], { stdio: "inherit" });
  }
  if (rest?.includes(".")) {
    execFileSync("tmux", ["select-pane", "-t", `${sessionPart}:${rest}`]);
  } else if (rest) {
    execFileSync("tmux", ["select-window", "-t", `${sessionPart}:${rest}`]);
  }
}

// has-session + plain new-session, not `-A -d`: `-A` only stays detached
// the first time a session is created — on an existing session it silently
// drops `-d` and attaches right here, inside the popup's own pty.
export function ensureSession(name, dir) {
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

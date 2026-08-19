// Pure box-drawing connector glyphs for the two nesting levels tmux-tree.mjs
// actually has: windows under a session, panes under a window. Kept
// separate from tmux-tree.mjs's domain labelling (naming, colour, node
// command description) so the connector math can be reasoned about on its
// own.

export function windowConnector(isLastWindow) {
  return isLastWindow ? "└─" : "├─";
}

// Trunk char reflects the parent window's position (whether its sibling
// windows continue below it), branch glyph reflects this pane's own
// position among its sibling panes.
export function paneConnector(isLastWindow, isLastPane) {
  const trunk = isLastWindow ? " " : "│";
  const branch = isLastPane ? "└─" : "├─";
  return `${trunk}  ${branch}`;
}

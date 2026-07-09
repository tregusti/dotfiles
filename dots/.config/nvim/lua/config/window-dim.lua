-- Dim inactive windows so it's obvious which one has focus (no visible cursor in
-- terminal windows like the Claude split otherwise). Lives here, not in
-- plugins/colorscheme.lua, since it's not a plugin or a theme — just a highlight
-- tweak reacting to whatever theme/background is currently active.

-- snacks.nvim windows (e.g. the Claude terminal) redirect NormalNC to their own
-- SnacksNormalNC group instead of reading the global one, so both need setting.
local SHADE = 0.9 -- 1.0 = no change, lower = darker

local function dim_inactive_windows()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if not normal.bg then
    return
  end

  local r = math.floor(normal.bg / 65536) % 256
  local g = math.floor(normal.bg / 256) % 256
  local b = normal.bg % 256

  local hex = string.format("#%02x%02x%02x", math.floor(r * SHADE), math.floor(g * SHADE), math.floor(b * SHADE))

  vim.api.nvim_set_hl(0, "NormalNC", { bg = hex })
  vim.api.nvim_set_hl(0, "SnacksNormalNC", { bg = hex })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = dim_inactive_windows })
dim_inactive_windows()

-- Watches Flameshot's save folder for new screenshots, creates a Dropbox
-- shared link for each one, rewrites it to a direct-image URL, and puts it
-- on the clipboard. See /tmp/handoff-dotfiles-screenshot-dropbox-link.md
-- (or git history) for the full design rationale.

local DROPBOX_ROOT = os.getenv("HOME") .. "/Dropbox"
local WATCH_FOLDER = DROPBOX_ROOT .. "/Apps/Flameshots"
local SECRETS_FILE = hs.configdir .. "/dropbox/secrets.lua"

local RETRY_DELAYS = { 1, 2, 3, 4, 8 } -- seconds;

-- FSEvents can fire multiple change events for one file as it's written
-- (create, then modify) — dedup so a single screenshot only gets processed once.
local processedPaths = {}

local function notify(title, informativeText)
  hs.notify.new({ title = title, informativeText = informativeText }):send()
end

-- withdrawAfter(0) keeps the notification up until dismissed, instead of the
-- default auto-disappear. Only for the startup "disabled" case — if you miss
-- that one, you won't know the watcher isn't running at all. Per-screenshot
-- notifications stay transient.
local function notifyPersistent(title, informativeText)
  hs.notify.new({ title = title, informativeText = informativeText }):withdrawAfter(0):send()
end

local function loadSecrets()
  local chunk = loadfile(SECRETS_FILE)
  if not chunk then
    return nil
  end
  local secrets = chunk()
  if secrets.app_key == "" or secrets.app_secret == "" or secrets.refresh_token == "" then
    return nil
  end
  return secrets
end

-- hs.http.encodeForQuery percent-encodes a single string; it doesn't build a
-- query string from a table, so join the pairs ourselves.
local function encodeFormBody(params)
  local pairs_ = {}
  for key, value in pairs(params) do
    table.insert(pairs_, hs.http.encodeForQuery(key) .. "=" .. hs.http.encodeForQuery(value))
  end
  return table.concat(pairs_, "&")
end

local function getAccessToken(secrets, callback)
  local body = encodeFormBody({
    grant_type = "refresh_token",
    refresh_token = secrets.refresh_token,
    client_id = secrets.app_key,
    client_secret = secrets.app_secret,
  })
  hs.http.asyncPost(
    "https://api.dropboxapi.com/oauth2/token",
    body,
    { ["Content-Type"] = "application/x-www-form-urlencoded" },
    function(status, respBody)
      if status ~= 200 then
        callback(nil, "token exchange failed (" .. status .. "): " .. respBody)
        return
      end
      local decoded = hs.json.decode(respBody)
      callback(decoded.access_token, nil)
    end
  )
end

-- Path relative to WATCH_FOLDER, e.g. "/20260902-093000.png". The Dropbox
-- app has "App folder" access, so the API root ("/") IS this folder already
-- — not the Dropbox account root — and paths must be relative to it.
local function dropboxRelativePath(localPath)
  return localPath:sub(#WATCH_FOLDER + 1)
end

-- Shared links look like "...?rlkey=xxx&dl=0" (other query params before
-- dl=0, not always right after "?"), so match dl=0 at the end regardless of
-- what precedes it rather than assuming "?dl=0" exactly.
local function rewriteToDirectLink(url)
  return (url:gsub("dl=0$", "raw=1"))
end

-- Fallback for the "already exists" case below, where the 409 doesn't carry
-- the existing link's URL — Dropbox says to fetch it via list_shared_links.
local function findExistingLink(accessToken, relativePath, callback)
  local body = hs.json.encode({ path = relativePath, direct_only = true })
  hs.http.asyncPost("https://api.dropboxapi.com/2/sharing/list_shared_links", body, {
    ["Authorization"] = "Bearer " .. accessToken,
    ["Content-Type"] = "application/json",
  }, function(status, respBody)
    if status ~= 200 then
      callback(nil, "list_shared_links failed (" .. status .. "): " .. respBody)
      return
    end
    local links = hs.json.decode(respBody).links
    if not links or not links[1] then
      callback(nil, "list_shared_links returned no links for " .. relativePath)
      return
    end
    callback(links[1].url, nil)
  end)
end

local function createSharedLink(accessToken, relativePath, callback, attempt)
  attempt = attempt or 1
  local body = hs.json.encode({ path = relativePath })
  hs.http.asyncPost("https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings", body, {
    ["Authorization"] = "Bearer " .. accessToken,
    ["Content-Type"] = "application/json",
  }, function(status, respBody)
    if status == 200 then
      callback(hs.json.decode(respBody).url, nil)
      return
    end

    -- A link for this path may already exist (e.g. a prior attempt whose
    -- response was lost before we saw success). Dropbox's 409 doesn't always
    -- include the existing URL, so look it up instead of treating it as
    -- a hard failure.
    local decoded = status == 409 and hs.json.decode(respBody)
    if decoded and decoded.error and decoded.error[".tag"] == "shared_link_already_exists" then
      if decoded.error.metadata and decoded.error.metadata.url then
        callback(decoded.error.metadata.url, nil)
      else
        findExistingLink(accessToken, relativePath, callback)
      end
      return
    end

    local delay = RETRY_DELAYS[attempt]
    if delay then
      hs.timer.doAfter(delay, function()
        createSharedLink(accessToken, relativePath, callback, attempt + 1)
      end)
      return
    end

    callback(nil, "create_shared_link failed (" .. status .. "): " .. respBody)
  end)
end

local function handleNewScreenshot(localPath)
  local secrets = loadSecrets()
  if not secrets then
    -- pathwatcher() below already warns once at startup if secrets are
    -- missing entirely; this covers the file appearing/disappearing later.
    notify("Dropbox screenshot link failed", "dropbox-secrets.lua missing")
    return
  end

  getAccessToken(secrets, function(accessToken, tokenErr)
    if tokenErr then
      notify("Dropbox screenshot link failed", tokenErr)
      return
    end

    local relativePath = dropboxRelativePath(localPath)
    createSharedLink(accessToken, relativePath, function(url, linkErr)
      if linkErr then
        notify("Dropbox screenshot link failed", linkErr)
        return
      end

      hs.pasteboard.setContents(rewriteToDirectLink(url))
      notify("Link copied", relativePath)
    end)
  end)
end

local function start()
  if not loadSecrets() then
    notifyPersistent(
      "Dropbox screenshot watcher disabled",
      "dropbox-secrets.lua missing — see dropbox-secrets.lua.example"
    )
    return
  end

  if not hs.fs.attributes(WATCH_FOLDER) then
    notifyPersistent("Dropbox screenshot watcher disabled", WATCH_FOLDER .. " not found")
    return
  end

  hs.pathwatcher
    .new(WATCH_FOLDER, function(paths)
      for _, path in ipairs(paths) do
        if path:match("%.png$") and hs.fs.attributes(path) and not processedPaths[path] then
          processedPaths[path] = true
          handleNewScreenshot(path)
        end
      end
    end)
    :start()
end

start()

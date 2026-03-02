if true then return {} end
-- ~/.config/nvim/lua/razor_panic.lua
local M = {}
M.enabled = false

-- Hard cap (2 GB). Endre ved behov (bytes).
local GC_CAP = "2147483648"

local function is_razor_buf(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.bo[bufnr].filetype == "razor"
end

local function patch_client_caps(client)
  if not client or (client.is_stopped and client:is_stopped()) then
    return
  end
  local name = string.lower(client.name or "")
  if name:find("razor") or name:find("rzls") or name:find("roslyn") then
    if client.server_capabilities then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.semanticTokensProvider = nil
    end
  end
end

local function apply_to_existing_clients(bufnr)
  for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
    patch_client_caps(client)
  end
end

local function disable_autoformat_for_buf(bufnr)
  vim.b[bufnr].autoformat = false -- spiller fint med LazyVim/Conform
  -- Skru av :Format i denne buffer (så du ikke trigger format ved et uhell)
  pcall(vim.api.nvim_buf_create_user_command, bufnr, "Format", function()
    vim.notify("Razor panic: format er deaktivert i denne buffer", vim.log.levels.WARN)
  end, { force = true })
end

local function enable_env_cap()
  -- Gjelder nye LSP-prosesser etter dette.
  vim.env.DOTNET_GCHeapHardLimit = GC_CAP
  vim.env.DOTNET_gcServer = "1"
end

local function clear_env_cap()
  vim.env.DOTNET_GCHeapHardLimit = nil
  vim.env.DOTNET_gcServer = nil
end

local function on_attach_event(args)
  if not M.enabled then
    return
  end
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  local bufnr = args.buf
  if is_razor_buf(bufnr) then
    patch_client_caps(client)
    disable_autoformat_for_buf(bufnr)
  end
end

local function on_filetype_event(args)
  if not M.enabled then
    return
  end
  local bufnr = args.buf
  if is_razor_buf(bufnr) then
    disable_autoformat_for_buf(bufnr)
    apply_to_existing_clients(bufnr)
  end
end

function M.enable()
  if M.enabled then
    vim.notify("Razor panic mode er allerede PÅ", vim.log.levels.INFO)
    return
  end
  M.enabled = true
  enable_env_cap()

  M.augroup = vim.api.nvim_create_augroup("RazorPanicMode", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = M.augroup,
    callback = on_attach_event,
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = M.augroup,
    pattern = { "razor" },
    callback = on_filetype_event,
  })

  if is_razor_buf(0) then
    disable_autoformat_for_buf(0)
    apply_to_existing_clients(0)
  end

  vim.notify(
    "Razor panic: PÅ (format off, semantic tokens off, GC cap aktiv). Tips: :LspRestart.",
    vim.log.levels.WARN
  )
end

function M.disable()
  if not M.enabled then
    vim.notify("Razor panic mode er allerede AV", vim.log.levels.INFO)
    return
  end
  M.enabled = false
  clear_env_cap()
  if M.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, M.augroup)
    M.augroup = nil
  end
  vim.notify("Razor panic: AV. Kjør :LspRestart for å gjenopprette capabilities.", vim.log.levels.INFO)
end

function M.setup()
  vim.api.nvim_create_user_command("RazorPanicOn", function()
    M.enable()
  end, {})
  vim.api.nvim_create_user_command("RazorPanicOff", function()
    M.disable()
  end, {})
  vim.keymap.set("n", "<leader>rp", function()
    if M.enabled then
      M.disable()
    else
      M.enable()
    end
  end, { desc = "Toggle Razor Panic Mode" })
end

return M

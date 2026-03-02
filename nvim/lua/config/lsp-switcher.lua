if true then
  return {}
end

local M = {}

-- State file path
local state_file = vim.fn.stdpath("data") .. "/lsp-switcher-state.json"

-- Available LSP modes
M.LSP_MODES = {
  RAZOR = "razor",
  OMNISHARP = "omnisharp"
}

-- Current LSP mode (default to omnisharp for stability)
M.current_mode = M.LSP_MODES.OMNISHARP

-- Load state from file
local function load_state()
  local file = io.open(state_file, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and data.lsp_mode then
      M.current_mode = data.lsp_mode
    end
  end
end

-- Save state to file
local function save_state()
  local data = { lsp_mode = M.current_mode }
  local file = io.open(state_file, "w")
  if file then
    file:write(vim.json.encode(data))
    file:close()
  end
end

-- Get current LSP mode
function M.get_current_mode()
  return M.current_mode
end

-- Check if razor mode is active
function M.is_razor_mode()
  return M.current_mode == M.LSP_MODES.RAZOR
end

-- Check if omnisharp mode is active
function M.is_omnisharp_mode()
  return M.current_mode == M.LSP_MODES.OMNISHARP
end

-- Get all C# and Razor buffers
local function get_csharp_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == "cs" or ft == "razor" or ft == "cshtml" then
        table.insert(buffers, buf)
      end
    end
  end
  return buffers
end

-- Switch LSP servers using direct LSP management
local function switch_lsp_servers()
  -- Stop all current C# LSP clients
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    if client.name == "roslyn" or client.name == "omnisharp" then
      vim.lsp.stop_client(client.id, true)
    end
  end
  
  -- Clear plugin cache to allow fresh loading
  package.loaded["plugins.razor"] = nil  
  package.loaded["plugins.omnisharp"] = nil
  
  -- Wait for clients to stop, then manually configure and start the appropriate LSP
  vim.defer_fn(function()
    if M.current_mode == M.LSP_MODES.RAZOR then
      -- Configure and start Razor.nvim (roslyn)
      local mason_registry = require("mason-registry")
      local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      
      if vim.fn.isdirectory(rzls_path) == 1 then
        local cmd = {
          "roslyn",
          "--stdio",
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
          "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
          "--extension",
          vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
        }
        
        -- Configure roslyn
        local lspconfig = require("lspconfig")
        lspconfig.roslyn.setup({
          cmd = cmd,
          handlers = require("rzls.roslyn_handlers"),
          filetypes = { "cs", "razor", "cshtml" },
          settings = {
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
            },
          },
        })
        
        -- Start roslyn for C# buffers
        local buffers = get_csharp_buffers()
        for _, buf in ipairs(buffers) do
          lspconfig.roslyn.manager.try_add_wrapper(buf)
        end
      else
        vim.notify("Razor LSP tools not found. Please install with :MasonInstall rzls roslyn", vim.log.levels.ERROR)
        return
      end
      
    else
      -- Configure and start OmniSharp
      local lspconfig = require("lspconfig")
      lspconfig.omnisharp.setup({
        cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
        filetypes = { "cs", "razor", "cshtml" },
        root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = false,
          },
        },
      })
      
      -- Start omnisharp for C# buffers
      local buffers = get_csharp_buffers()
      for _, buf in ipairs(buffers) do
        lspconfig.omnisharp.manager.try_add_wrapper(buf)
      end
    end
    
    -- Final notification  
    local mode_name = M.current_mode == M.LSP_MODES.RAZOR and "Razor.nvim" or "OmniSharp"
    vim.notify(
      string.format("✅ Switched to %s", mode_name),
      vim.log.levels.INFO,
      { title = "LSP Switcher" }
    )
  end, 1000)
end

-- Toggle between LSP modes
function M.toggle_lsp()
  local old_mode = M.current_mode
  
  if M.current_mode == M.LSP_MODES.RAZOR then
    M.current_mode = M.LSP_MODES.OMNISHARP
  else
    M.current_mode = M.LSP_MODES.RAZOR
  end
  
  -- Save the new state
  save_state()
  
  -- Show immediate feedback
  local mode_name = M.current_mode == M.LSP_MODES.RAZOR and "Razor.nvim" or "OmniSharp"
  vim.notify(
    string.format("🔄 Switching to %s...", mode_name),
    vim.log.levels.INFO,
    { title = "LSP Switcher" }
  )
  
  -- Switch the LSP servers
  switch_lsp_servers()
  
  return M.current_mode
end

-- Get status string for statusline
function M.get_status()
  local icon = M.current_mode == M.LSP_MODES.RAZOR and "⚡" or "🔧"
  local name = M.current_mode == M.LSP_MODES.RAZOR and "Razor" or "OmniSharp"
  return string.format("%s %s", icon, name)
end

-- Initialize the module
local function init()
  load_state()
  
  -- Create user command
  vim.api.nvim_create_user_command("LspToggle", function()
    M.toggle_lsp()
  end, { desc = "Toggle between Razor.nvim and OmniSharp LSP" })
  
  -- Add autocmd to show current mode on VimEnter
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local mode_name = M.current_mode == M.LSP_MODES.RAZOR and "Razor.nvim" or "OmniSharp"
      vim.defer_fn(function()
        vim.notify(
          string.format("LSP Mode: %s", mode_name),
          vim.log.levels.INFO,
          { title = "LSP Switcher", timeout = 3000 }
        )
      end, 1000)
    end,
  })
end

-- Initialize when module is loaded
init()

return M
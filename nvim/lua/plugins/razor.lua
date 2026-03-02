-- ~/.config/nvim/lua/plugins/razor.lua
if true then
  --roslyn is now built in to easy_dotnet and is enabled by default
  return {}
end

local mason_registry = require("mason-registry")

local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
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

return {
  -- 1) Mason + extra registry so rzls/roslyn show up
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry", -- adds rzls + roslyn
      }
      return opts
    end,
  },
  -- 5) Treesitter highlightin
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        "tris203/rzls.nvim",
        config = true,
      },
    },
    config = function()
      -- Use one of the methods in the Integration section to compose the command.

      vim.lsp.config("roslyn", {
        cmd = cmd,
        handlers = require("rzls.roslyn_handlers"),
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      vim.lsp.enable("roslyn")
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local ensure = opts.ensure_installed
      local function ensure_lang(lang)
        if type(ensure) == "table" then
          for _, l in ipairs(ensure) do
            if l == lang then
              return
            end
          end
          table.insert(ensure, lang)
        end
      end
      ensure_lang("razor")
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}
      opts.servers.html = {
        filetypes = { "html" }, -- exclude "razor" and "cshtml"
        settings = {
          html = {
            -- (optional) if you still see warnings in plain html:
            validate = { scripts = false, styles = false },
          },
        },
      }
      return opts
    end,
  },
  -- { "OmniSharp/omnisharp-vim", enabled = false },
  -- Disable omnisharp when using razor.nvim
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts = opts or {}
  --     opts.servers = opts.servers or {}
  --     -- Disable omnisharp when in razor mode
  --     opts.servers.omnisharp = false
  --     return opts
  --   end,
  -- },
}

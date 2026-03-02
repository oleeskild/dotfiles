return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Cliffback/netcoredbg-macOS-arm64.nvim",
    },
    opts = function()
      local dap = require("dap")

      -- Setup ARM64 netcoredbg for macOS
      require("netcoredbg-macOS-arm64").setup(dap)

      -- Register easy-dotnet variables viewer
      require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
    end,
  },
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}

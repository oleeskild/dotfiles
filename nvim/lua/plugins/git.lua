return {
  {
    "sindrets/diffview.nvim",
    config = function()
      -- Optional: your own Diffview setup
      require("diffview").setup({})

      -- Set q to close Diffview, only when inside a Diffview buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "DiffviewFiles", "DiffviewFileHistory" },
        callback = function()
          vim.keymap.set("n", "q", "<cmd>DiffviewClose<CR>", { buffer = true, silent = true })
        end,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional, for diff integration
      "folke/snacks.nvim", -- optional
    },
    config = function()
      require("neogit").setup({})
      vim.keymap.set("n", "<leader>gn", function()
        require("neogit").open()
      end, { desc = "Open Neogit" })
      vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
      vim.keymap.set("n", "<leader>gw", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
    end,
  },
}

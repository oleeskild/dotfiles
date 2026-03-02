-- lua/plugins/noice.lua
return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts = opts or {}
    opts.routes = opts.routes or {}

    -- Add route to skip roslyn progress messages
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local client = vim.tbl_get(message.opts, "progress", "client")
          return client and client.name == "roslyn"
        end,
      },
      opts = { skip = true },
    })

    -- Add route to skip rzls progress messages
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local client = vim.tbl_get(message.opts, "progress", "client")
          return client and client.name == "rzls"
        end,
      },
      opts = { skip = true },
    })

    return opts
  end,
}

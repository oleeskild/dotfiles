if true then
  return {}
end

-- Blazor files times out the LSP. Same issue in VSCode actually. So this is probably a roslyn on mac issue
return {
  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },
}

# 💤 LazyVim Configuration

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## LSP Switcher for C# Development

This configuration includes a custom LSP switcher that allows you to toggle between two C# LSP options:

- **Razor.nvim** (with roslyn LSP) - Better for Razor/Blazor development with advanced features
- **OmniSharp** - More stable, traditional C# LSP with enhanced capabilities

### Usage

- `<leader>cw` - Toggle between Razor.nvim and OmniSharp LSP
- `<leader>cL` - Show current LSP mode
- `:LspToggle` - Command to toggle LSP mode

### Features

- **Clean Plugin Management**: LazyVim's omnisharp extra is disabled; we manage both LSPs completely
- **True Mode Switching**: Only one LSP configuration is loaded at a time
- **Plugin Reload**: Uses Lazy.nvim's reload functionality for seamless switching
- **State persistence** across sessions
- **Visual notifications** when switching
- **Enhanced OmniSharp**: Includes omnisharp-extended-lsp for better go-to-definition
- **Full Razor Support**: Complete rzls.nvim integration when in Razor mode

### Technical Details

The switcher works by:

1. Conditionally loading plugin configurations based on current mode
2. Using Lazy.nvim's reload mechanism to switch configurations
3. Stopping old LSP clients and starting new ones after reload
4. Persisting mode choice in a state file

The configuration defaults to OmniSharp for stability. Switch to Razor mode when you need advanced Razor/Blazor features.

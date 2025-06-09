# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration using Lua and the lazy.nvim plugin manager.
The configuration emphasizes performance through lazy loading and provides a comprehensive development environment with LSP support, AI assistance, and Git integration.

## Key Commands

### Plugin Management
- `:Lazy` - Open lazy.nvim UI to manage plugins
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Sync plugins with lazy-lock.json

### LSP Commands
- `:Mason` - Open Mason UI to manage LSP servers
- `:LspInfo` - Show LSP client information
- `:LspLog` - View LSP log

### Common Development Tasks
- Format code: `<leader>rf` (in normal mode)
- Code actions: `<leader>ra`
- Rename symbol: `<leader>rr`
- Go to definition: `gd`
- Find references: `gr`

## Architecture

### Entry Points
1. `/init.lua` → `/lua/digia/init.lua` - Main configuration loader
2. Plugin configurations are modularized in `/lua/digia/plugin/`

### Configuration Structure
- **Options & Keymaps**: Core Neovim settings in `lua/digia/options.lua` and `lua/digia/keymaps.lua`
- **Plugin Categories**:
  - `ui.lua`: Themes, statusline, visual enhancements
  - `coding.lua`: Completion, snippets, AI assistance (Copilot, Avante)
  - `lsp.lua`: Language servers, diagnostics, formatting
  - `git.lua`: Git integration (Gitsigns, Neogit)
  - `telescope.lua`: Fuzzy finding and search
  - `treesitter.lua`: Syntax highlighting and text objects

### Key Patterns
- Leader key is space (`<leader>`)
- Keybinding prefixes follow consistent patterns:
  - `<leader>f*` - File operations
  - `<leader>s*` - Search operations
  - `<leader>g*` - Git operations
  - `<leader>v*` - LSP operations
- Plugins use lazy loading with specific events (`VeryLazy`, `InsertEnter`, etc.)
- Environment variables for API keys are loaded from `~/.config/nvim/.env`

### Notable Behaviors
- Automatically removes trailing whitespace on save
- Creates parent directories when saving new files
- Uses treesitter-based folding (Neovim 0.10+)
- Avante.nvim configuration switches between Claude and Copilot based on hostname

# Plan: Add Telescope command to show all files

## Goal
Create a new Telescope keybinding similar to '<leader>fp' that shows all files in the project directory, including those ignored by .gitignore.

## Current Behavior
- `<leader>fp` uses `Telescope find_files` which respects .gitignore
- Uses ripgrep with: `rg --files --color never -g !.git`

## Solution
1. Add a new keybinding `<leader>fP` (capital P) for "Find All Files"
2. Create a custom Telescope command that uses ripgrep with --no-ignore flag
3. This will show all files including:
   - Files in .gitignore
   - Hidden files
   - Build artifacts
   - Dependencies (node_modules, etc.)

## Implementation Details
- Keybinding: `<leader>fP`
- Description: "Find All Files (inc. ignored)"
- Command: Custom Telescope picker with find_command using --no-ignore
- Location: Add to the Files section in telescope.lua (after line 28)

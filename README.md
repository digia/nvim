# nvim

Personal Neovim configuration. See `CLAUDE.md` for the architecture overview.

## Vim/Neovim Wiki

A running log of Vim/Neovim internals worth remembering - collected here so they don't have to be
re-learned from scratch.

### `ftdetect/` vs. `ftplugin/` vs. `after/ftplugin/`

Three directories, three different jobs in the filetype pipeline.

- **`ftdetect/<ft>.lua`** — runs early, answers *"what filetype is this buffer?"* Contains autocmds like `BufRead`/`BufNewFile` that set `filetype` for patterns Neovim doesn't already recognize.
- **`ftplugin/<ft>.lua`** — runs *after* filetype is set, answers *"now that I know it's `<ft>`, configure this buffer."* Buffer-local options, keymaps, and commands scoped to that filetype. Neovim sources the *first* `ftplugin/<ft>.lua` it finds on the runtimepath.
- **`after/ftplugin/<ft>.lua`** — same as `ftplugin/` but sourced at the *end* of the runtimepath, after all earlier ones (built-ins, plugins). Use this when you need to override settings a plugin's own ftplugin applied.

**Rule of thumb:** ftdetect = naming the file, ftplugin = configuring the buffer, after/ftplugin = having the last word.

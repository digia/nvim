-- Only required if you have packer in your `opt` pack `~/.local/share/nvim/site/*`
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  if vim.fn.input('Download Packer? [y/n] ') ~= 'y' then
    print('Packer download cancelled')
    return
  end

  local directory = string.format(
    '%s/site/pack/packer/opt/',
    vim.fn.stdpath('data')
  )

  vim.fn.mkdir(directory, 'p')

  local stdout = vim.fn.system(string.format(
    'git clone %s %s',
    'https://github.com/wbthomason/packer.nvim',
    directory .. '/packer.nvim'
  ))

  print(stdout)
  print('Downloading packer.nvim...')

  return
end

return require('packer').startup {
  function(use)
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    use 'nvim-lua/popup.nvim' -- tjdevries "An implementation of the Popup API from vim in Neovim."
    use 'nvim-lua/plenary.nvim' -- tjdevries "All the lua functions I don't want to write twice."

    -- Find, Filter, Preview, Pick
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    -- use {'junegunn/fzf', run = './install --all' }     -- Fuzzy Searcher
    -- use {'junegunn/fzf.vim'}

    -- Advanced tmux and vim synergy
    use 'tmux-plugins/vim-tmux-focus-events'

    -- Killing buffers without loosing split
    use 'qpkorr/vim-bufkill'

    -- Automatically create missing directories when saving
    use 'benizi/vim-automkdir'

    -- Better support for joins
    use 'AndrewRadev/splitjoin.vim'

    -- git changes within the signcolumn
    use 'airblade/vim-gitgutter'

    -- Visual line indention
    use 'Yggdroot/indentLine'

    -- Better comment support
    use 'preservim/nerdcommenter'

    -- TODO(digia): provide comments/context for the plugins
    use 'tpope/vim-dispatch'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-unimpaired'

    -- Language specific plugins
    use 'sheerun/vim-polyglot'

    -- Lua
    use 'euclidianAce/BetterLua.vim'
  end
}

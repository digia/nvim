-- Set up file type detection for symlink files (e.g. strategy used within Dotfiles repo)
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.symlink",
  callback = function(args)
    -- Get the filename without .symlink suffix
    local filename = vim.fn.fnamemodify(args.file, ":t")
    local base_filename = filename:gsub("%.symlink$", "")

    -- Try to detect filetype from the base filename
    local filetype = vim.filetype.match({ filename = base_filename })

    -- If no match found, try with a dot prefix (for config files)
    if not filetype then
      filetype = vim.filetype.match({ filename = "." .. base_filename })
    end

    -- Set the filetype if one was found
    if filetype then
      vim.bo.filetype = filetype
    end
  end,
})

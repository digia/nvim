return {
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", "<cmd>Git<cr>" },
            { "<leader>gd", "<cmd>Git diff<cr>" },
            { "<leader>gc", "<cmd>Git commit<cr>" },
            { "<leader>gb", "<cmd>Git blame<cr>" },
            { "<leader>gl", "<cmd>Git log<cr>" },
        },
    },

    -- TODO: Finish setting up gitsigns (https://github.com/lewis6991/gitsigns.nvim)
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function() require("gitsigns").setup() end,
    },
}

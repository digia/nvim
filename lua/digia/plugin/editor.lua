return {
    { "qpkorr/vim-bufkill" }, -- Killing buffers without loosing split
    { "benizi/vim-automkdir" }, -- Automatically create missing directories when saving
    { "AndrewRadev/splitjoin.vim" }, -- Better support for joins (gS, gJ)

    -- TODO: Silence tpope/unimpaired commands from showing within cmdline
    { "tpope/vim-unimpaired" }, -- [<Space>, ]<Space>, [u, ]u, [f, ]f, [e, ]e

    { "tpope/vim-repeat" }, -- Repeat more than native commands
    { "tpope/vim-dispatch" }, -- Dispatch async tasks
    { "tpope/vim-surround" }, -- cs'"

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- Source for text in buffer
            "hrsh7th/cmp-path", -- Source for file system paths
            -- TODO: Investigate if this is ideal
            "hrsh7th/cmp-cmdline",
            {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- Install jsregexp (optional)
                build = "make install_jsregexp",
            },
            "saadparwaiz1/cmp_luasnip", -- For autocompletion
            "rafamadriz/friendly-snippets", -- Useful snippets
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load() -- NOTE: `luasnip.loaders.from_vscode.lazy_load()` breaks

            cmp.setup({
                -- view = {
                    -- LSP popup entries end up being behind the completion menu (?)
                    -- entries = "native",
                -- },
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    -- ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion, prev
                    -- NOTE: Might of taken this from ThePrimeagen, not sure why else to use <C-y>...
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion, new (?)

                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Testing bindings from https://github.com/zazencodes/dotfiles/blob/main/nvim/lua/plugins/lsp.lua
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),

                    -- NOTE: Trying out the more complex mappings from Zazencodes, 
                    --  Zazencodes had these as <Tab> and <S-Tab>...
                    -- ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    -- ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

                    -- Select next/prev item in completion menu
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-p>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- Snippets
                    { name = "buffer" }, -- Text within the current buffer
                    { name = "path" }, -- File system paths
                }, {
                })
            })
        end

    },

    -- Autopairing
    {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true, -- Enable treesitter
                ts_config = {
                    lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
                    javascript = { "template_string" }, -- Don't add pairs in javascript template string treesitter nodes
                    java = false, -- Don't check treesitter for java
                },
            })

            -- Configure autopairs to work with cmp
            local autopairs_cmp = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done())
        end,
    },

    -- Formatting (TODO) https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/formatting.lua
    -- return {
        -- "stevearch/conformat.nvim",
    -- }
}

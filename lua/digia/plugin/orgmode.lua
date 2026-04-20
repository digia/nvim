local local_config = require("digia.local_config")
local brain_dir = vim.fn.expand(local_config.get("brain_dir", "~/Code/digia/digia-brain"))

return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<cr>",            desc = "Org capture" },
      { "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<cr>",             desc = "Org agenda" },
      { "<leader>ol", "<cmd>lua require('orgmode').action('org_mappings.store_link')<cr>",   desc = "Org store link" },
      { "<leader>oI", "<cmd>lua require('orgmode').action('org_mappings.store_link')<cr>",   desc = "Org add/get ID for current heading" },
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = { brain_dir .. "/**/*" },
        org_default_notes_file = brain_dir .. "/inbox.org",

        org_tags_column = -101,
        org_startup_folded = "content",

        org_hide_emphasis_markers = false,
        org_src_fontify_natively = true,
        -- org_hide_leading_stars = true,
        -- org_startup_indented = true,

        -- Start the week on Sunday (0) instead of Monday (1)
        calendar_week_start_day = 0,
        org_agenda_start_on_weekday = 0,

        org_todo_keywords = { "TODO", "NEXT", "INPROGRESS", "WAITING", "|", "DONE", "CANCELLED" },
        -- Per-keyword coloring (overrides the binary @org.keyword.todo / .done
        -- defaults). Accepted face props: foreground, background, weight,
        -- slant, underline. Use color names, #rrggbb, or cterm numbers.
        -- org_todo_keyword_faces = {
        --   TODO       = ":foreground #e06c75 :weight bold",
        --   NEXT       = ":foreground #61afef :weight bold",
        --   INPROGRESS = ":foreground #d19a66 :weight bold",
        --   WAITING    = ":foreground #c678dd :weight bold :slant italic",
        --   DONE       = ":foreground #98c379 :weight bold",
        --   CANCELLED  = ":foreground #5c6370 :weight bold :slant italic",
        -- },
        org_log_into_drawer = "LOGBOOK",
        org_log_done = "time",

        org_confirm_babel_evaluate = false,

        org_id_link_to_org_use_id = true,

        mappings = {
          org = {
            -- Tmux (leader = C-Space) eats the default <C-Space> binding.
            -- <C-t> is normally tag-pop, but unused in org notes — reclaim it here
            -- as "control toggle".
            org_toggle_checkbox = "<C-t>",
          },
        },

        org_capture_templates = {
          t = {
            description = "Todo (daily)",
            template = "* TODO %?\n%U",
            target = brain_dir .. "/daily/%<%Y-%m-%d>.org",
          },
          n = {
            description = "Note (inbox)",
            template = "* %U %?",
            target = brain_dir .. "/inbox.org",
          },
          m = {
            description = "Meeting (daily)",
            template = "* MEETING %? :meeting:\n%U",
            target = brain_dir .. "/daily/%<%Y-%m-%d>.org",
          },
        },
      })

      -- Experimental: enable orgmode's built-in LSP for document/workspace
      -- symbols, references, and completion.
      vim.lsp.enable("org")

      -- Org highlight overrides live here. Orgmode links its @org.* treesitter
      -- groups to standard groups (Title, Constant, Identifier, …) — see
      -- lua/orgmode/colors/highlights.lua in the plugin for the full list.
      -- Redefine via `vim.api.nvim_set_hl(0, <group>, { fg = ..., bold = ... })`
      -- inside this callback, then call :so % or restart.
      local function apply_org_highlights()
        -- Examples — uncomment and tweak:
        -- vim.api.nvim_set_hl(0, "@org.headline.level1", { fg = "#c678dd", bold = true })
        -- vim.api.nvim_set_hl(0, "@org.headline.level2", { fg = "#61afef", bold = true })
        -- vim.api.nvim_set_hl(0, "@org.headline.level3", { fg = "#98c379" })
        -- vim.api.nvim_set_hl(0, "@org.headline.level4", { fg = "#e5c07b" })
        -- vim.api.nvim_set_hl(0, "@org.tag",             { fg = "#56b6c2", italic = true })
        -- vim.api.nvim_set_hl(0, "@org.timestamp.active", { fg = "#d19a66" })
        -- vim.api.nvim_set_hl(0, "@org.checkbox.checked", { fg = "#98c379", bold = true })
        -- vim.api.nvim_set_hl(0, "@org.properties",      { fg = "#5c6370", italic = true })
        -- vim.api.nvim_set_hl(0, "@org.bullet",          { fg = "#5c6370" })

        -- Binary TODO/DONE coloring (covers ALL undone vs done keywords).
        -- For per-keyword coloring, prefer `org_todo_keyword_faces` in setup().
        -- vim.api.nvim_set_hl(0, "@org.keyword.todo", { fg = "#e06c75", bold = true })
        -- vim.api.nvim_set_hl(0, "@org.keyword.done", { fg = "#98c379", bold = true })

        -- Tame source blocks + inline code. Orgmode links these to @comment /
        -- @markup.raw, which in most themes is yellow/orange — louder than
        -- render-markdown.nvim's subtle treatment. Explicit bg/fg so you can
        -- tune both without worrying about highlight-group inheritance chains.
        local code_hl = {
          bg = "#414868",  -- matches render-markdown's inline code bg
          fg = "#7aa2f7",  -- matches render-markdown's inline code fg
        }
        for _, g in ipairs({
          "@org.block",
          "@org.block.delimiter",
          "@org.code",
          "@org.code.delimiter",
          "@org.verbatim",
          "@org.verbatim.delimiter",
          "@org.inline_block",
        }) do
          vim.api.nvim_set_hl(0, g, code_hl)
        end
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("digia.org_highlights", { clear = true }),
        callback = apply_org_highlights,
      })
      apply_org_highlights()
    end,
  },

  {
    "chipsenkbeil/org-roam.nvim",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = { "nvim-orgmode/orgmode" },
    keys = {
      { "<leader>of",  function() require("org-roam").api.find_node() end, desc = "Roam find node" },
      { "<leader>oi",  function() require("org-roam").api.insert_node() end, desc = "Roam insert link" },
      { "<leader>ob",  function() require("org-roam").ui.toggle_node_buffer() end, desc = "Roam backlinks buffer" },
      { "<leader>odt", function() require("org-roam").ext.dailies.goto_today() end, desc = "Daily: today" },
      { "<leader>ody", function() require("org-roam").ext.dailies.goto_yesterday() end, desc = "Daily: yesterday" },
      { "<leader>odd", function() require("org-roam").ext.dailies.goto_date() end, desc = "Daily: pick date" },
    },
    config = function()
      require("org-roam").setup({
        directory = brain_dir,
        database = {
          path = brain_dir .. "/org-roam.db",
        },
        extensions = {
          dailies = {
            directory = "daily",
            templates = {
              d = {
                description = "default",
                template = "",
                target = "%<%Y-%m-%d>.org",
              },
            },
          },
        },
      })

      -- org-roam's goto_* writes `#+TITLE: YYYY-MM-DD` into new daily buffers.
      -- Rewrite to `#+title: YYYY-MM-DD, Day - Daily` before the user saves.
      local daily_glob = brain_dir .. "/daily/*.org"
      vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("digia.org_roam_daily_title", { clear = true }),
        pattern = daily_glob,
        callback = function(args)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            local name = vim.api.nvim_buf_get_name(args.buf)
            if vim.fn.filereadable(name) == 1 then return end

            local fname = vim.fn.fnamemodify(name, ":t:r")
            local y, m, d = fname:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
            if not y then return end

            local ts = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
            local pretty = "Daily - " .. os.date("%Y-%m-%d, %a", ts)

            local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false)
            for i, line in ipairs(lines) do
              if line:match("^#%+TITLE:%s+%d%d%d%d%-%d%d%-%d%d%s*$") then
                vim.api.nvim_buf_set_lines(args.buf, i - 1, i, false, { "#+title: " .. pretty })
                return
              end
            end
          end)
        end,
      })
    end,
  },

  {
    "hamidi-dev/org-super-agenda.nvim",
    cmd = { "OrgSuperAgenda" },
    dependencies = { "nvim-orgmode/orgmode" },
    keys = {
      { "<leader>oad", "<cmd>OrgSuperAgenda d<cr>", desc = "Super-agenda: daily dashboard" },
      { "<leader>oaw", "<cmd>OrgSuperAgenda w<cr>", desc = "Super-agenda: weekly review" },
      { "<leader>oat", "<cmd>OrgSuperAgenda t<cr>", desc = "Super-agenda: all open TODOs" },
    },
    opts = {
      views = {
        d = {
          title = "Daily Dashboard",
          groups = {
            { type = "agenda", title = "Today",       span = "day" },
            { type = "todo",   title = "In Progress", match = "INPROGRESS" },
            { type = "todo",   title = "Waiting",     match = "WAITING" },
          },
        },
        w = {
          title = "Weekly Review",
          groups = {
            { type = "agenda", title = "This Week",   span = "week" },
            { type = "todo",   title = "By Priority", order_by = "priority" },
            { type = "todo",   title = "By State",    order_by = "todo_state" },
          },
        },
        t = {
          title = "Open TODOs",
          groups = {
            { type = "todo", title = "By Priority", order_by = "priority" },
            { type = "todo", title = "By State",    order_by = "todo_state" },
          },
        },
      },
    },
  },
}

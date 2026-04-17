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
        org_log_into_drawer = "LOGBOOK",
        org_log_done = "time",

        org_confirm_babel_evaluate = false,

        org_id_link_to_org_use_id = true,

        -- Tmux (leader = C-Space) eats the default <C-Space> binding.
        -- <C-t> is normally tag-pop, but unused in org notes — reclaim it here
        -- as "control toggle".
        mappings = {
          org = {
            org_toggle_checkbox = "<C-t>",
          },
        },

        org_capture_templates = {
          t = {
            description = "Todo (daily)",
            template = "* TODO %?\n  %U",
            target = brain_dir .. "/daily/%<%Y-%m-%d>.org",
          },
          n = {
            description = "Note (inbox)",
            template = "* %U %?\n",
            target = brain_dir .. "/inbox.org",
          },
          m = {
            description = "Meeting (daily)",
            template = "* MEETING %? :meeting:\n  %U",
            target = brain_dir .. "/daily/%<%Y-%m-%d>.org",
          },
        },
      })
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

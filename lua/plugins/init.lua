return {
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  -- LSP configuration moved to lua/plugins/lsp.lua

  {
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {}
    end,
  },

  { 'github/copilot.vim' },

  -- Copilot Chat for asking questions about code
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = true, -- Enable debugging
      model = 'grok-code-fast-1', -- Use Grok model
      auto_insert_mode = true, -- Automatically insert mode for suggestions
      insert_at_end = false,   -- Insert suggestions at cursor position instead of end
      window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.8,     -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8,    -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = 'editor',
        border = 'single',    -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil,             -- row position of the window, default is centered
        col = nil,             -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil,          -- footer of chat window
        zindex = 1,            -- determines if window is on top or below other floating windows
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = '<C-a>',
          insert = '<C-a>'
        },
        show_diff = {
          normal = 'gd',
          insert = 'gd'
        },
        show_system_prompt = {
          normal = 'gp',
          insert = 'gp'
        },
        show_user_selection = {
          normal = 'gs',
          insert = 'gs'
        },
      },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Load custom Copilot utilities
      local copilot_utils = require('core.copilot_utils')

      -- Keymaps for Copilot Chat - Enhanced for agentic workflow
      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Open Copilot Chat" })
      vim.keymap.set("v", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Open Copilot Chat with selection" })

      -- Quick agentic commands
      vim.keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain code" })
      vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain selected code" })
      vim.keymap.set("n", "<leader>ct", "<cmd>CopilotChatTests<cr>", { desc = "Generate tests" })
      vim.keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix code" })
      vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDocs<cr>", { desc = "Document code" })
      vim.keymap.set("n", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review code" })
      vim.keymap.set("n", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize code" })

      -- Agentic workflow keybindings - these make changes easy to apply
      vim.keymap.set("n", "<leader>ca", "<cmd>CopilotChatApply<cr>", { desc = "Apply Copilot suggestion" })
      vim.keymap.set("v", "<leader>ca", "<cmd>CopilotChatApply<cr>", { desc = "Apply Copilot suggestion to selection" })

      -- Quick agentic actions with prompts
      vim.keymap.set("n", "<leader>crf", ":CopilotChat refactor this function<cr>", { desc = "Refactor current function" })
      vim.keymap.set("v", "<leader>crf", ":CopilotChat refactor this code<cr>", { desc = "Refactor selected code" })

      vim.keymap.set("n", "<leader>cim", ":CopilotChat improve this function<cr>", { desc = "Improve current function" })
      vim.keymap.set("v", "<leader>cim", ":CopilotChat improve this code<cr>", { desc = "Improve selected code" })

      vim.keymap.set("n", "<leader>cre", ":CopilotChat rewrite this<cr>", { desc = "Rewrite current function" })
      vim.keymap.set("v", "<leader>cre", ":CopilotChat rewrite this<cr>", { desc = "Rewrite selected code" })

      vim.keymap.set("n", "<leader>cmt", ":CopilotChat add type hints<cr>", { desc = "Add type hints to function" })
      vim.keymap.set("v", "<leader>cmt", ":CopilotChat add type hints to this code<cr>", { desc = "Add type hints to selection" })

      -- Quick insertion mode for asking Copilot questions
      vim.keymap.set("n", "<leader>cq", ":<C-U>CopilotChat ", { desc = "Quick Copilot question" })
      vim.keymap.set("v", "<leader>cq", ":<C-U>CopilotChat ", { desc = "Quick Copilot question with selection" })

      -- Enhanced agentic workflow keybindings
      vim.keymap.set("n", "<leader>cp", copilot_utils.quick_copilot_command, { desc = "Quick Copilot commands menu" })
      vim.keymap.set("v", "<leader>cp", copilot_utils.quick_copilot_command, { desc = "Quick Copilot commands menu with selection" })

      -- Easy apply with utilities
      vim.keymap.set("n", "<leader>cya", copilot_utils.apply_copilot_suggestion, { desc = "Yank Copilot suggestion" })
      vim.keymap.set("v", "<leader>cya", copilot_utils.replace_with_copilot, { desc = "Replace selection with Copilot suggestion" })

      -- Advanced agentic workflow commands
      vim.keymap.set("n", "<leader>cas", ":CopilotChat convert this to use structs<cr>", { desc = "Convert to structs" })
      vim.keymap.set("v", "<leader>cas", ":CopilotChat convert this selection to use structs<cr>", { desc = "Convert selection to structs" })

      vim.keymap.set("n", "<leader>cap", ":CopilotChat add proper error handling<cr>", { desc = "Add error handling" })
      vim.keymap.set("v", "<leader>cap", ":CopilotChat add proper error handling to this code<cr>", { desc = "Add error handling to selection" })

      vim.keymap.set("n", "<leader>cac", ":CopilotChat add comments and documentation<cr>", { desc = "Add comments/docs" })
      vim.keymap.set("v", "<leader>cac", ":CopilotChat add comments and documentation to this code<cr>", { desc = "Add comments/docs to selection" })

      vim.keymap.set("n", "<leader>caf", ":CopilotChat make this function async<cr>", { desc = "Make function async" })
      vim.keymap.set("v", "<leader>caf", ":CopilotChat make this code async<cr>", { desc = "Make selection async" })

      vim.keymap.set("n", "<leader>cad", ":CopilotChat add debug logging<cr>", { desc = "Add debug logging" })
      vim.keymap.set("v", "<leader>cad", ":CopilotChat add debug logging to this code<cr>", { desc = "Add debug logging to selection" })

      vim.keymap.set("n", "<leader>cat", ":CopilotChat add unit tests<cr>", { desc = "Add unit tests" })
      vim.keymap.set("v", "<leader>cat", ":CopilotChat add unit tests for this code<cr>", { desc = "Add unit tests for selection" })

      -- Quick multi-step workflows
      vim.keymap.set("n", "<leader>cwf", ":CopilotChat fix and optimize this function<cr>", { desc = "Fix and optimize function" })
      vim.keymap.set("v", "<leader>cwf", ":CopilotChat fix and optimize this code<cr>", { desc = "Fix and optimize selection" })

      vim.keymap.set("n", "<leader>cwc", ":CopilotChat clean up and document this code<cr>", { desc = "Clean up and document" })
      vim.keymap.set("v", "<leader>cwc", ":CopilotChat clean up and document this selection<cr>", { desc = "Clean up and document selection" })

      -- In chat buffer keybindings for easy application
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "copilot-chat",
        callback = function()
          vim.keymap.set("n", "<C-y>", "<cmd>CopilotChatApply<cr>", { buffer = true, desc = "Apply suggestion" })
          vim.keymap.set("n", "<C-r>", "<cmd>CopilotChatReset<cr>", { buffer = true, desc = "Reset chat" })
          vim.keymap.set("n", "<C-s>", "<cmd>CopilotChatSave<cr>", { buffer = true, desc = "Save chat" })
          -- Additional quick actions in chat buffer
          vim.keymap.set("n", "<C-a>", copilot_utils.apply_copilot_suggestion, { buffer = true, desc = "Yank code block" })
        end,
      })
    end,
  },

  -- {
  --   'hrsh7th/nvim-cmp',
  --   dependencies = {
  --     'L3MON4D3/LuaSnip',
  --     'saadparwaiz1/cmp_luasnip',
  --     'hrsh7th/cmp-nvim-lsp',
  --     'rafamadriz/friendly-snippets',
  --   },
  -- },

  { 'folke/which-key.nvim', opts = {} },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
        local gs = package.loaded.gitsigns
        vim.keymap.set({'n', 'v'}, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        vim.keymap.set({'n', 'v'}, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      end,
    },
  },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "tokyonight",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {},
  },

  { 'numToStr/Comment.nvim', opts = {} },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  -- Treesitter configuration moved to lua/plugins/treesitter.lua

  { import = 'plugins' },
}


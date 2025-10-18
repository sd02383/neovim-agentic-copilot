return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  build = ':TSUpdate',
  config = function()
    -- Add custom tree-sitter predicates
    local ts = vim.treesitter
    
    -- Add all potentially missing predicates
    local predicates = {
      ["has-ancestor?"] = function(match, pattern, bufnr, pred)
        local node = match[pred[2]]
        if not node or type(node) ~= "userdata" then return false end

        local ancestor_type = pred[3]
        if not ancestor_type then return false end
        
        local ok, ancestor = pcall(function() return node:parent() end)
        if not ok or not ancestor then return false end

        while ancestor do
          local ok_type, node_type = pcall(function() return ancestor:type() end)
          if ok_type and node_type == ancestor_type then
            return true
          end
          ok, ancestor = pcall(function() return ancestor:parent() end)
          if not ok then break end
        end

        return false
      end,

      ["not-has-parent?"] = function(match, pattern, bufnr, pred)
        local node = match[pred[2]]
        if not node or type(node) ~= "userdata" then return false end

        local parent_type = pred[3]
        if not parent_type then return false end
        
        local ok, parent = pcall(function() return node:parent() end)
        if not ok or not parent then return true end

        local ok_type, node_type = pcall(function() return parent:type() end)
        if not ok_type then return false end
        
        return node_type ~= parent_type
      end,

      ["has-parent?"] = function(match, pattern, bufnr, pred)
        local node = match[pred[2]]
        if not node or type(node) ~= "userdata" then return false end

        local parent_type = pred[3]
        if not parent_type then return false end
        
        local ok, parent = pcall(function() return node:parent() end)
        if not ok or not parent then return false end

        local ok_type, node_type = pcall(function() return parent:type() end)
        if not ok_type then return false end
        
        return node_type == parent_type
      end
    }

    -- Register predicates only if not already defined
    for name, handler in pairs(predicates) do
      if not ts.query.get_predicate_handler then
        -- Fallback for older tree-sitter versions
        ts.query.add_predicate(name, handler, true)
      else
        if not ts.query.get_predicate_handler(name) then
          ts.query.add_predicate(name, handler, true)
        end
      end
    end

    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}

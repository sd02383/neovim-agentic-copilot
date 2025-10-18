return {
  -- No longer need nvim-lspconfig plugin with Neovim 0.11+
  -- Using built-in vim.lsp.config instead
  'williamboman/mason.nvim',
  dependencies = {
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    'folke/neodev.nvim',
  },
  config = function()
    -- Setup mason first
    require('mason').setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    
    -- Get capabilities. This will use cmp capabilities if available, otherwise it will use default capabilities.
    local capabilities
    local status_ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
    if status_ok then
      capabilities = cmp_caps.default_capabilities()
    else
      capabilities = vim.lsp.protocol.make_client_capabilities()
    end

    local on_attach = function(client, bufnr)
      -- LSP keymaps
      local opts = { buffer = bufnr, silent = true }
      
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

      -- Format command using clang-format directly
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.cmd("silent !clang-format -i " .. vim.fn.expand("%"))
        vim.cmd("edit") -- Reload the file
      end, { desc = 'Format current buffer with clang-format' })
    end

    -- Setup clangd using the new vim.lsp.config API
    -- Note: Install clangd via Mason with :MasonInstall clangd
    vim.lsp.config.clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--fallback-style=file", -- Use 'file' style as a fallback
      },
      capabilities = capabilities,
      on_attach = on_attach,
    }
    
    -- Enable clangd for C/C++ files
    vim.lsp.enable('clangd')
    
    -- Setup rust-analyzer using the new vim.lsp.config API
    vim.lsp.config.rust_analyzer = {
      cmd = { 'rust-analyzer' },
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy',
          },
        },
      },
    }
    
    -- Enable rust-analyzer for Rust files
    vim.lsp.enable('rust_analyzer')
  end
}





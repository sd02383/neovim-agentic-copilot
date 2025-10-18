# Modern Neovim Configuration with Agentic Copilot

A powerful, modern Neovim setup featuring **agentic Copilot integration** that rivals Cursor's AI-powered coding experience.

## ✨ Features

### 🚀 Agentic Copilot Workflow
- **One-click code improvements**: `<leader>cim` to improve functions
- **Smart refactoring**: `<leader>crf` for instant refactoring
- **Error handling**: `<leader>cap` adds proper error handling
- **Async conversion**: `<leader>caf` converts functions to async
- **Multi-step workflows**: `<leader>cwf` fixes and optimizes code

### 🛠️ Development Tools
- **Full LSP support** for multiple languages (C/C++, Rust, Python, etc.)
- **Debugging** with DAP (C/C++, Rust, Python, Java)
- **Treesitter** for advanced syntax highlighting
- **Git integration** with Gitsigns
- **File explorer** with NvimTree
- **Fuzzy finding** with Telescope

### 🎨 UI & Experience
- **Tokyo Night** theme
- **Lualine** status line
- **Indent guides** with Indent Blankline
- **WhichKey** for keybinding hints
- **Auto-formatting** for C/C++ with clang-format

## 📦 Installation

### Prerequisites
- **Neovim 0.9+**
- **Node.js 18+** (for Copilot)
- **GitHub Copilot subscription**
- **clang-format** (for C/C++ formatting)

### Quick Setup
```bash
# Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone <your-repo-url> ~/.config/nvim

# Install plugins
cd ~/.config/nvim
# Launch Neovim - plugins will install automatically via lazy.nvim
nvim

# Setup Copilot
:Copilot setup
```

## 🎯 Agentic Copilot Usage

### Quick Commands
| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>cc` | Open Chat | Interactive Copilot chat |
| `<leader>cp` | Quick Menu | Select from common actions |
| `<leader>cim` | Improve Code | Enhance selected code |
| `<leader>crf` | Refactor | Refactor function/code |
| `<leader>cap` | Add Errors | Add error handling |
| `<leader>cac` | Add Docs | Add comments/documentation |
| `<leader>caf` | Make Async | Convert to async |
| `<leader>cwf` | Fix+Optimize | Complete code improvement |

### In Chat Window
- `<C-y>` → **Apply suggestion** (like Cursor's accept)
- `<C-a>` → Copy code block
- `<C-r>` → Reset chat
- `<C-s>` → Save chat

### Example Workflow
1. Select problematic code
2. Press `<leader>cim` (improve)
3. Review suggestions in floating chat
4. Press `<C-y>` → **Code applies instantly!**

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua              # Main configuration
├── lua/
│   ├── core/            # Core Neovim settings
│   │   ├── options.lua  # Vim options
│   │   ├── keymaps.lua  # Keybindings
│   │   ├── copilot_utils.lua  # Agentic Copilot helpers
│   │   └── ...
│   └── plugins/         # Plugin configurations
│       ├── init.lua     # Plugin definitions
│       ├── lsp.lua      # LSP setup
│       ├── debug.lua    # DAP setup
│       └── ...
├── lazy-lock.json       # Plugin lockfile
└── README.md           # This file
```

## 🗝️ Keybindings

### Leader Key: `<Space>`

#### Copilot (Agentic)
- `<leader>c*` → All Copilot commands
- `<leader>cc` → Open chat
- `<leader>cp` → Quick action menu

#### LSP
- `gd` → Go to definition
- `gr` → Find references
- `K` → Hover documentation
- `<leader>rn` → Rename symbol
- `<leader>ca` → Code actions

#### Git
- `<leader>hp` → Preview hunk

#### Debugging
- `<F5>` → Start/continue
- `<F1>` → Step into
- `<F2>` → Step over
- `<F3>` → Step out
- `<leader>b` → Toggle breakpoint

## 🤝 Contributing

Feel free to open issues or PRs! This config is designed to be:
- **Modular** - easy to customize
- **Well-documented** - clear comments
- **Modern** - uses latest Neovim features

## 📄 License

MIT License - feel free to use and modify!

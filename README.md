# Neovim Configuration

![Neovim Logo](https://neovim.io/logos/neovim-logo-300x87.png)

This repository contains my personal Neovim configuration. My goal with this config is to have rich features of a modern text-editor that are tailored to my needs and to write the entire config in `lua`.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configurations](#configurations)
- [Plugins](#plugins)
- [Colorschemes](#colorschemes)
- [License](#license)
- [Acknowledgements](#Acknowledgments)

## Prerequisites

Install neovim with your package manager.

Homebrew:
```sh
brew install neovim
```

## Installation

1. Clone this repository to your Neovim configuration directory:
   ```sh
   git clone https://github.com/danielt812/nvim-config ~/.config/nvim
   ```
2. Open `nvim` and wait for plugins and lsps to install.
3. Exit out of Neovim for the changes to take effect.
4. Run `:checkhealth` the next time you open `nvim`
5. Install missing service providers (python, node)

- Neovim python service provider:
```sh
pip install pynvim
```
- Neovim node service provider:
```sh
npm i -g neovim
```
## Configurations

Keymaps, options and autocmds can be found in `lua/config`:
- [Options](https://github.com/danielt812/nvim-config/tree/main/lua/config/options.lua)
- [Keymaps](https://github.com/danielt812/nvim-config/tree/main/lua/config/keymaps.lua)
- [Autocmds](https://github.com/danielt812/nvim-config/tree/main/lua/config/autocmds.lua)

## Plugins

Plugins specs and their configurations can be found in `lua/plugins`:
- [Alpha](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/alpha.lua)
- [Autopairs](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/autopairs.lua)
- [Bufferline](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/bufferline.lua)
- [Completions](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/cmp.lua)
- [Comments](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/comment.lua)
- [Git Blame](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/git-blame.lua)
- [Git Signs](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/gitsigns.lua)
- [Hop](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/hop.lua)
- [Illuminate](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/illuminate.lua)
- [Indent Line](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/indentline.lua)
- [LSP](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/lsp.lua)
- [LuaLine](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/lualine.lua)
- [Mason](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/mason.lua)
- [Null-ls](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/null-ls.lua)
- [Nvim-tree](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/nvim-tree.lua)
- [Oil](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/oil.lua)
- [Spectre](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/spectre.lua)
- [Surround](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/surround.lua)
- [Telescope](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/telescope.lua)
- [Todo-comments](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/todo-comments.lua)
- [Treesitter](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/treesitter.lua)
- [Treesj](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/treesj.lua)
- [Trouble](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/trouble.lua)
- [Which-Key](https://github.com/danielt812/nvim-config/tree/main/lua/plugins/which-key.lua)

Configuring new plugins can be found at [LazyNvim :zzz:](https://github.com/folke/lazy.nvim)

## Colorschemes

Themes can be found in `lua/colorschemes`. The one I am currently using is the `carbonfox` variant of [nightfox](https://github.com/EdenEast/nightfox.nvim/blob/main/readme.md). This can be changed by setting the colorscheme spec to:
```lua
return {
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      ...
    }
  end,
  config = function(_, opts)
    require("COLORSCHEME").setup(opts)
    vim.cmd("colorscheme COLORSCHEME")
  end
}
 ```

### Installed Colorschemes:
- [Catppuccin](https://github.com/catppuccin/nvim)
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [Nightfox](https://github.com/EdenEast/nightfox.nvim)
- [Rose-Pine](https://github.com/rose-pine/neovim)
- [TokyoNight](https://github.com/folke/tokyonight.nvim)

## License

This project is licensed under the [MIT License](LICENSE). You are free to use and modify this configuration to suit your needs.

## Acknowledgments

This config was inspired by pre-configured Neovim frameworks such as:
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [LunarVim](https://github.com/LunarVim/LunarVim)

---

Thank you for checking out my Neovim configuration! If you have any questions or need help, don't hesitate to reach out. Happy coding! :rocket:

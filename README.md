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
2. Open `nvim` and wait for plugins, tree-sitter parsers and language service providers to install.
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

Configuring new plugins can be found at [LazyNvim :zzz:](https://github.com/folke/lazy.nvim)

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

## License

This project is licensed under the [MIT License](LICENSE). You are free to use and modify this configuration to suit your needs.

---

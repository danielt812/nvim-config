local M = { "kevinhwang91/nvim-ufo" }

M.enabled = false

M.event = { "BufRead" }

M.dependencies = { "kevinhwang91/promise-async" }

M.init = function()
  vim.keymap.set("n", "zR", "<cmd>lua require('ufo').openAllFolds<CR>")
  vim.keymap.set("n", "zM", "<cmd>lua require('ufo').closeAllFolds<CR>")
  vim.keymap.set("n", "zr", "<cmd>lua require('ufo').openFoldsExceptKinds<CR>")
  vim.keymap.set("n", "zm", "<cmd>lua require('ufo').closeFoldsWith<CR>") -- closeAllFolds == closeFoldsWith(0)
end

M.opts = function()
  return {
    preview = {
      mappings = {
        scrollB = "<C-b>",
        scrollF = "<C-f>",
        scrollU = "<C-u>",
        scrollD = "<C-d>",
      },
    },
    provider_selector = function(_, filetype, buftype)
      local function handleFallbackException(bufnr, err, providerName)
        if type(err) == "string" and err:match("UfoFallbackException") then
          return require("ufo").getFolds(bufnr, providerName)
        else
          return require("promise").reject(err)
        end
      end

      return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
        or function(bufnr)
          return require("ufo")
            .getFolds(bufnr, "lsp")
            :catch(function(err)
              return handleFallbackException(bufnr, err, "treesitter")
            end)
            :catch(function(err)
              return handleFallbackException(bufnr, err, "indent")
            end)
        end
    end,
  }
end

M.config = function(_, opts)
  require("ufo").setup(opts)
end

return M

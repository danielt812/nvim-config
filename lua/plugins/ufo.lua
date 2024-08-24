local M = { "kevinhwang91/nvim-ufo" }

M.enabled = true

M.event = { "VeryLazy" }

M.keys = {
  { "zR", "<cmd>lua require('ufo').openAllFolds()<cr>", desc = "Open All Folds" },
  { "zM", "<cmd>lua require('ufo').closeAllFolds()<cr>", desc = "Close All Folds" },
}

M.dependencies = { "kevinhwang91/promise-async" }

M.opts = function()
  local handler = function(virtText, lnum, endLnum, width, truncate, ctx)
    local filling = " ... "
    local suffix = (" %d lines "):format(endLnum - lnum)
    local suffixWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - suffixWidth
    local curWidth = 0
    table.insert(virtText, { filling, "Folded" })
    local endVirtText = ctx.get_fold_virt_text(endLnum)
    for i, chunk in ipairs(endVirtText) do
      local chunkText = chunk[1]
      local hlGroup = chunk[2]
      if i == 1 then
        chunkText = chunkText:gsub("^%s+", "")
      end
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(virtText, { chunkText, hlGroup })
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        table.insert(virtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(virtText, { suffix, "Folded" })
    return virtText
  end

  return {
    enable_get_fold_virt_text = true,
    fold_virt_text_handler = handler,
    preview = {
      mappings = {
        scrollB = "<C-b>",
        scrollF = "<C-f>",
        scrollU = "<C-u>",
        scrollD = "<C-d>",
      },
    },
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  }
end

M.config = function(_, opts)
  require("ufo").setup(opts)
end

return M

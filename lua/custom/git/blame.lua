local M = {}

function M.current_line()
  local bufnr = vim.fn.bufnr()
  local line, col = vim.fn.line("."), vim.fn.col(".")
  local line_text = vim.fn.getline(line)
  local _, text_indent = vim.text.indent(0, line_text)
  local diagnostic_indent = text_indent + vim.bo[bufnr].shiftwidth

  local filename = vim.fn.fnamemodify(vim.fn.bufname(), ":p")

  vim.system({ "git", "blame", filename, "-L", line .. "," .. line }, {}, function(out)
    local text
    local hl
    if out.code ~= 0 then
      text = "No information: " .. out.stderr
      hl = "DiagnosticError"
    else
      text = string.gsub(out.stdout, "([^ ]+) %((.*) %d+%).*", "%1 (%2)", 1)
      hl = "DiagnosticInfo"
    end

    vim.schedule(function()
      local ns_id = vim.api.nvim_create_namespace("custom.git_blame")
      local virt_lines = {
        { { vim.text.indent(diagnostic_indent, text), hl } },
      }

      vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, col - 1, {
        virt_lines = virt_lines,
        virt_lines_above = false,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        callback = function()
          vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
        end,
      })
    end)
  end)
end

return M

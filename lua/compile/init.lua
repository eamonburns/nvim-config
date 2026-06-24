local M = {}

---Window-ID
---@type integer|nil
local compile_term_window = nil

---@return integer the terminal window
local function open_term_window()
  -- TODO: Make configurable
  if compile_term_window and vim.api.nvim_win_is_valid(compile_term_window) then
    vim.api.nvim_set_current_win(compile_term_window)
  else
    compile_term_window = vim.api.nvim_open_win(0, true, {
      vertical = true,
      split = "right",
      win = -1, -- Top-level split
    })
  end
  return compile_term_window
end

local function setup_buf_keymaps(buf)
  vim.keymap.set("n", "<Plug>(CompileNextError)", function()
    vim.fn.search([[^ *\zs\f\+:\d\+]])
  end, { buf = buf })

  vim.keymap.set("n", "<Plug>(CompilePrevError)", function()
    vim.fn.search([[^ *\zs\f\+:\d\+]], "b")
  end, { buf = buf })

  vim.keymap.set("n", "<Plug>(CompileGoToErrorFile)", function()
    local file = vim.fn.expand("<cfile>")
    if vim.fn.findfile(file) == "" then
      vim.notify(([[E447: Can't find file "%s" in path]]):format(file), vim.log.levels.ERROR)
      return
    end
    vim.api.nvim_set_current_win(vim.w[compile_term_window].compile_calling_window)
    vim.cmd.find(file)
  end, { buf = buf })

  vim.keymap.set("n", "<Plug>(CompileGoToErrorFileLine)", function()
    local file = vim.fn.expand("<cfile>")
    if vim.fn.findfile(file) == "" then
      vim.notify(([[E447: Can't find file "%s" in path]]):format(file), vim.log.levels.ERROR)
      return
    end

    ---@type { byteidx: integer, lnum: integer, text: string, submatches: string[] }
    ---@diagnostic disable-next-line: assign-type-mismatch # The return value of matchbufline was wrongly typed
    local match = vim.fn.matchbufline(vim.fn.bufnr(), [[\f\+:\(\d\+\)\(:\d\+\)\?]], vim.fn.line("."), vim.fn.line("."), {
      submatches = true,
    })[1]

    local line = tonumber(match.submatches[1])
    local opt_col = nil
    if match.submatches[2] ~= "" then
      opt_col = tonumber(match.submatches[2]:sub(2))
    end
    local calling_win = vim.w[compile_term_window].compile_calling_window
    vim.api.nvim_set_current_win(calling_win)
    vim.cmd.find(file)
    vim.api.nvim_win_set_cursor(calling_win, { line, (opt_col or 1) - 1 })
  end, { buf = buf })
end

---@type string|nil
local last_compile_cmd = nil

---@param cmd string
---@param nargs integer # Number of arguments
function M.compile(cmd, nargs)
  vim.validate("cmd", cmd, "string")

  if nargs == 0 then
    if last_compile_cmd then
      cmd = last_compile_cmd
    else
      vim.notify("No previous command to run", vim.log.levels.ERROR)
      return
    end
  end

  local calling_window = vim.fn.win_getid()

  local win = open_term_window()

  vim.w[win].compile_calling_window = calling_window
  vim.cmd.terminal(cmd)
  local buf = vim.fn.bufnr()

  setup_buf_keymaps(buf)

  vim.bo[buf].bufhidden = "delete"
  vim.bo[buf].buflisted = false
  vim.bo[buf].filetype = "compile-cmd"

  last_compile_cmd = cmd
end

return M

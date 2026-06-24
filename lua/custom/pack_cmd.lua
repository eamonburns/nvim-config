local functions = {
  ---@param fargs string[]|nil
  ---@param cmd_args vim.api.keyset.create_user_command.command_args
  update = function(fargs, cmd_args)
    if #fargs == 0 then
      fargs = nil
    end
    vim.pack.update(fargs, { force = cmd_args.bang })
  end,

  ---@param fargs string[]|nil
  ---@param cmd_args vim.api.keyset.create_user_command.command_args
  view = function(fargs, cmd_args)
    if #fargs == 0 then
      fargs = nil
    end
    vim.pack.update(fargs, { offline = true })
  end,

  ---@param fargs string[]|nil
  ---@param cmd_args vim.api.keyset.create_user_command.command_args
  sync = function(fargs, cmd_args)
    if #fargs == 0 then
      fargs = nil
    end
    vim.pack.update(fargs, {
      force = cmd_args.bang,
      target = "lockfile",
    })
  end,
}

---@param cmdline string
local function complete_pack(_, cmdline, _)
  local argv = vim.split(cmdline, " ", { trimempty = true })
  if #argv == 1 then
    return vim.tbl_keys(functions)
  end

  local subcmd = argv[2]
  if functions[subcmd] then -- subcmd is a valid sub-command
    -- Complete names of plugins not already in the command line

    -- Remove `Pack <subcmd>` from argv
    table.remove(argv, 1)
    table.remove(argv, 1)
    return vim
      -- Get all plugins
      .iter(vim.pack.get(nil, { info = false }))
      -- Get the name of the plugins
      :map(function(p)
        return p.spec.name
      end)
      -- Filter out plugins that are already in the arguments
      :filter(function(p)
        return not vim.list_contains(argv, p)
      end)
      :totable()
  end
end

vim.api.nvim_create_user_command("Pack", function(args)
  local fargs = args.fargs
  -- NOTE: Arguments must be supplied
  local subcmd = table.remove(fargs, 1) -- Remove `<subcmd>` from fargs
  local f = functions[subcmd]
  if f then
    f(fargs, args)
  else
    print("Pack: invalid sub command: " .. subcmd)
  end
end, {
  complete = complete_pack,
  nargs = "+",
  force = true,
  bang = true,
})

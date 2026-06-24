-- vim.api.nvim_create_autocmd("FileType", {
--   callback = function(ev) end,
-- })

vim.api.nvim_create_user_command("Compile", function(args)
  require("compile").compile(args.args, #args.fargs)
end, {
  nargs = "*",
  complete = "shellcmdline",
})

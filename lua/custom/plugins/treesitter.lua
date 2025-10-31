return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",

  -- TODO: Add custom parsers

  --         -- Custom parsers
  --         supermd = {
  --           install_info = {
  --             url = "https://github.com/kristoff-it/supermd",
  --             location = "tree-sitter/supermd",
  --             files = {
  --               "src/parser.c",
  --               "src/scanner.c",
  --             },
  --             branch = "main",
  --             queries_dir = "tree-sitter/supermd/queries",
  --           },
  --         },
  --         supermd_inline = {
  --           install_info = {
  --             url = "https://github.com/kristoff-it/supermd",
  --             location = "tree-sitter/supermd-inline",
  --             files = {
  --               "src/parser.c",
  --               "src/scanner.c",
  --             },
  --             branch = "main",
  --             queries_dir = "tree-sitter/supermd-inline/queries",
  --           },
  --         },

  --       -- Add filetypes
  --       vim.filetype.add { extension = { smd = "supermd" } }

  init = function()
    -- Automatically download parser for current file if available and not already installed
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_autostart", { clear = true }),
      callback = function(args)
        local treesitter = require("nvim-treesitter")
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.list_contains(treesitter.get_available(), lang) then
          if not vim.list_contains(treesitter.get_installed(), lang) then
            -- TODO: Make this not block the entire interface.
            -- Currently, if a parser takes a long time to install (e.g. gitcommit takes a long time to compile),
            -- the UI will be blank for that long. Neovim should be usable while the parser is installing, and
            -- then treesitter should be started afterward
            treesitter.install(lang):wait()
          end
          vim.treesitter.start(args.buf)
        end
      end,
      desc = "Enable nvim-treesitter and install parser if not installed",
    })
  end,
}

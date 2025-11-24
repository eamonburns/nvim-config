return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",

  -- TODO: Add custom parsers: https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#adding-custom-languages

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
    -- TODO: Ensure commands are installed (e.g. tree-sitter, curl?)

    -- Automatically download parser for current file if available and not already installed
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_autostart", { clear = true }),
      callback = function(args)
        local treesitter = require("nvim-treesitter")
        local lang = vim.treesitter.language.get_lang(args.match)

        if lang and vim.list_contains(treesitter.get_available(), lang) then
          if not vim.list_contains(treesitter.get_installed(), lang) then
            -- Install parser and then start treesitter
            treesitter.install(lang):await(function()
              vim.treesitter.start(args.buf)
            end)
          else
            -- Start treesitter
            vim.treesitter.start(args.buf)
          end
        end
      end,
      desc = "Automatically start treesitter for buffer (installing parser if not already)",
    })
  end,
}

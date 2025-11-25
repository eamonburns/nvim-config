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
  end,
}

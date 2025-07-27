local install_dir = vim.fn.stdpath("data") .. "/site"
return {
  {
    "lewis6991/ts-install.nvim",
    opts = {
      auto_install = true,
      install_dir = install_dir,
      parsers = {
        -- Custom parsers
        supermd = {
          install_info = {
            url = "https://github.com/kristoff-it/supermd",
            location = "tree-sitter/supermd",
            files = {
              "src/parser.c",
              "src/scanner.c",
            },
            branch = "main",
            queries_dir = "tree-sitter/supermd/queries",
          },
        },
        supermd_inline = {
          install_info = {
            url = "https://github.com/kristoff-it/supermd",
            location = "tree-sitter/supermd-inline",
            files = {
              "src/parser.c",
              "src/scanner.c",
            },
            branch = "main",
            queries_dir = "tree-sitter/supermd-inline/queries",
          },
        },
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      local function ts_start(bufnr, parser_name)
        vim.treesitter.start(bufnr, parser_name)
        -- Use regex based syntax-highlighting as fallback as some plugins might need it
        vim.bo[bufnr].syntax = "ON"
        -- Use treesitter for folds
        vim.wo.foldlevel = 99
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
        -- Use treesitter for indentation
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Auto-start parsers for any buffer
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable Treesitter automatically",
        group = vim.api.nvim_create_augroup("treesitter_autostart", {}),
        callback = function(event)
          local bufnr = event.buf
          local filetype = vim.bo[bufnr].filetype

          -- Skip if no filetype
          if filetype == "" then
            return
          end

          -- Get parser name based on filetype
          local parser_name = vim.treesitter.language.get_lang(filetype)
          if not parser_name then
            vim.notify("No treesitter parser found for filetype: " .. filetype, vim.log.levels.WARN)
            return
          end

          -- Try to get existing parser
          local parser_configs = require("nvim-treesitter.parsers")
          if not parser_configs[parser_name] then
            return -- Parser not available, skip silently
          end

          local parser_exists = pcall(vim.treesitter.get_parser, bufnr, parser_name)

          if parser_exists then
            -- Start treesitter for this buffer
            ts_start(bufnr, parser_name)
          else
            vim.notify(parser_name .. " parser not available.", vim.log.levels.INFO)
          end
        end,
      })

      -- Add filetypes
      vim.filetype.add { extension = { smd = "supermd" } }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    opts = { install_dir = install_dir },
    init = function()
      vim.g.loaded_nvim_treesitter = 1
    end,
  },
}

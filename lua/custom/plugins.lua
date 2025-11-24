local function gh(repo)
  return "https://github.com/" .. repo
end

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Run data.on_change callback when plugins are changed",
  group = vim.api.nvim_create_augroup("custom-plugin-changed", { clear = true }),
  callback = function(ev)
    if type(ev.data.spec.data) == "table" then
      local on_change = ev.data.spec.data and ev.data.spec.data.on_change
      if on_change then
        on_change(ev)
      end
    end
  end,
})

local plugins = {
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-lua/plenary.nvim"),

  gh("folke/tokyonight.nvim"),

  gh("stevearc/oil.nvim"), -- Requires "nvim-tree/nvim-web-devicons"

  gh("agent-e11/battery.nvim"), -- Requires "nvim-lua/plenary.nvim"

  gh("echasnovski/mini.nvim"),

  gh("lewis6991/gitsigns.nvim"),

  gh("folke/todo-comments.nvim"), -- Requires "nvim-lua/plenary.nvim"

  gh("windwp/nvim-autopairs"),
}

local lsp_plugins = require("custom.plugins.lsp")

plugins = vim.list_extend(plugins, lsp_plugins.plugins)

-- [[ Install plugins ]]
vim.pack.add(plugins)

-- [[ Configure plugins ]]

-- folke/tokyonight.nvim --
require("tokyonight").setup({
  styles = {
    comments = { italic = false }, -- Disable italics in comments
  },
})
vim.cmd.colorscheme("tokyonight-night")

-- LSP Plugins --
lsp_plugins.configure()

-- oil.nvim --
require("oil").setup {
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
}
vim.keymap.set("n", "-", "<cmd>Oil<cr>")

-- battery.nvim --
require("battery").setup({})

-- mini.nvim --
require("mini.tabline").setup({})

local statusline = require("mini.statusline")
statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        -- TODO: Find out if there is a way to simply add a sub-section to this group (i.e. the "battery" section),
        -- instead of needing to re-implement this whole function
        { hl = mode_hl, strings = { search, location, require("battery").get_status_line() } },
      }
    end,
  },
  use_icons = vim.g.have_nerd_font,
})

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

-- gitsigns.nvim --
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

-- todo-comments.nvim --
require("todo-comments").setup({
  signs = false,
})

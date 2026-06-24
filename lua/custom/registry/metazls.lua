local metazig_version = "1.0.0"

---@module 'mason-core.package'
---@type RegistryPackageSpec
return {
  schema = "registry+v1",
  name = "metazls",
  description = "Bla bla bla", -- TODO: Fix
  homepage = "https://codeberg.org/platypro/metazig",
  licenses = {
    "MIT", -- TODO: Fix me
  },
  languages = { "Zig" },
  categories = { "LSP" },
  source = {
    -- id = "pkg:codeberg/platypro/metazig@1.0.0",
    id = ("pkg:mason/platypro/metazig@%s"):format(metazig_version),
    ---@param ctx InstallContext
    install = function(ctx)
      do
        vim.notify("metazls Mason package is not implemented", vim.log.levels.WARN)
        return
      end
      ---@type string
      local file_name
      ---@type string
      local url
      ---@type "windows"|"linux"
      local os_name
      if vim.fn.has("win64") == 1 then
        file_name = "metazig-x86_64-windows.zip"
        url = ("https://codeberg.org/platypro/metazig/releases/download/%s/%s"):format(metazig_version, file_name)
        os_name = "windows"
      elseif vim.fn.has("linux") == 1 and jit.arch == "x64" then
        file_name = "metazig-x86_64-linux.tar.gz"
        url = ("https://codeberg.org/platypro/metazig/releases/download/%s/%s"):format(metazig_version, file_name)
        os_name = "linux"
      else
        error(("Invalid OS/Arch: %s %s"):format(jit.os, jit.arch))
      end

      ctx:fetch(url, {
        out_file = file_name,
      })

      if os_name == "windows" then
        ctx.spawn.unzip { file_name }
      else
        ctx.spawn.tar { "-xf", file_name }
      end
    end,
  },
  -- NOTE: Schema doesn't really work, since the schema could change between ZLS versions
  -- schemas = {
  --   lsp = "https://raw.githubusercontent.com/zigtools/zls/{{version}}/schema.json",
  -- },
  bin = {
    zls = "zls",
  },
  neovim = {
    lspconfig = "zls",
  },
}

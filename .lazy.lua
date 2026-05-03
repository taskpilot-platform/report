---@module 'lazy'
---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
      formatters = {
        typstyle = {
          append_args = {
            "--line-width=80",
            "--indent-width=2",
            "--wrap-text",
          },
        },
      },
    },
    optional = true,
  },
  {
    "KevinNitroG/vi-spell.vim",
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        command = "setlocal spell spelllang=vi,en spellfile+=./src/assets/spell/vi.utf-8.add",
      })
    end,
  },
}

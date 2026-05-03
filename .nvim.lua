vim.lsp.config.tinymist = {
  settings = {
    outputPath = "./build/",
    fontPaths = {
      "./src/assets/fonts/",
    },
    projectResolution = "lockDatabase",
    lint = {
      enabled = true,
    },
    preview = {
      refresh = "onSave",
    },
    formatterMode = "disable",
    formatterProseWrap = true,
    formatterPrintWidth = 80,
    formatterIndentSize = 4,
  },
}

vim.lsp.config.texlab = {
  settings = {
    texlab = {
      formatterLineLength = 120,
    },
  },
}

---@type integer?
local pin_typst_aucmd

pin_typst_aucmd = vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.typ",
  callback = function(arg)
    local client = vim.lsp.get_client_by_id(arg.data.client_id)
    if client == nil or client.name ~= "tinymist" then
      return
    end
    client:request("workspace/executeCommand", {
      command = "tinymist.pinMain",
      arguments = {
        vim.fn.fnamemodify("./src/main.typ", ":p"),
      },
    })
    ---@cast pin_typst_aucmd integer
    vim.api.nvim_del_autocmd(pin_typst_aucmd)
  end,
})

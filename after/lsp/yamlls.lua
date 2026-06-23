vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = false,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = {
          "manifests/**/*.yaml",
          "k8s/**/*.yaml",
          "kubernetes/**/*.yaml",
          "deploy/**/*.yaml",
          "templates/**/*.yaml",
          "chart/templates/**/*.yaml",
        },
      },
    },
  },
})

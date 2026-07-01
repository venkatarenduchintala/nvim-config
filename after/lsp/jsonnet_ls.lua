return {
  cmd = { "jsonnet-language-server", "-t" },
  settings = {
    ext_vars = {},
    formatting = {
      Indent = 2,
      MaxBlankLines = 2,
      StringStyle = "s",
      CommentStyle = "s",
      PrettyFieldNames = true,
      SortImports = true,
    },
  },
}

# askama.nvim

## Work in progress

## 📦 Installation

#### lazy.nvim

```lua
{
  "jorismertz/askama.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- Uncomment if `enable_snippets` is set to true
    -- "L3MON4D3/LuaSnip",
  },
  opts = {
    -- Branch for the askama treesitter parser (https://github.com/jorismertz/tree-sitter-htmlaskama)
    branch = "stable",
    -- What file extension should use the askama treesitter grammar
    file_extension = "html",
    -- Only files in these sub-directories will be treated as askama files
    template_dirs = { "templates", "views" },
    -- Set up some snippets for LuaSnip
    enable_snippets = false,
    -- Enable if you're using autopairs so snippets won't conflict
    -- snippet_autopairs = true,
  },
}
```

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

local M = {}

---@param path string
local function download_grammar(path)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/jorismertz/tree-sitter-htmlaskama.git",
    "--branch=" .. "main",
    path,
  })
end

---@param path string
---@return boolean
local function installed_grammar(path)
  if not vim.loop.fs_stat(path) then
    return false
  end

  return true
end

---@param type string -- injections, queries, class, etc
---@param content string
local function install_query(type, content)
  vim.treesitter.query.set("htmlaskama", type, content)
end

local function read_query_file(path)
  local content = vim.fn.readfile(path)
  return table.concat(content, "\n")
end

---@param parser_path string
local function install_queries(parser_path)
  local queries = {
    -- "class",
    "injections",
    "highlights",
  }

  for _, query in ipairs(queries) do
    local path = string.format("%s/queries/%s.scm", parser_path, query)
    local content = read_query_file(path)
    install_query(query, content)
  end
end

---@param opts AskamaConfig
function M.setup(opts)
  local path = vim.fn.stdpath("data") .. "/askama/grammar"

  if not opts.parser_path and not installed_grammar(path) then
    download_grammar(path)
  end

  ---@diagnostic disable-next-line
  parser_config.htmlaskama = {
    install_info = {
      url = opts.parser_path or path,
      files = { "src/parser.c", "src/scanner.c" },
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },

    filetype = opts.source_file_ext
  }

  require("nvim-treesitter.configs").setup {
    ensure_installed = "htmlaskama",
    autoinstall = true,
    highlight = {
      enable = true,
    },
  }

  install_queries(opts.parser_path or path)
end

return M

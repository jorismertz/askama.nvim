local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
local grammar_path = vim.fn.stdpath("data") .. "/askama/grammar"

local M = {}

local function download_grammar()
  if not vim.loop.fs_stat(grammar_path) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/jorismertz/tree-sitter-htmlaskama.git",
      "--branch=" .. "main",
      grammar_path,
    })
  end
end

---@return boolean
local function check_grammar()
  if not vim.loop.fs_stat(grammar_path) then
    return false
  end

  return true
end

---@param opts AskamaConfig
function M.setup(opts)
  if not check_grammar() then
    download_grammar()
  end

  ---@diagnostic disable-next-line
  parser_config.htmlaskama = {
    install_info = {
      url = grammar_path,
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
end

return M

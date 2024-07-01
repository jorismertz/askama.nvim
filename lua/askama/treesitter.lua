local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

local M = {}

local queries = {
  highlights = {
    "(tag_name) @tag",
    "(attribute_name) @attribute",
    "(quoted_attribute_value) @string",
    "(attribute_value) @string",
    "(extends_statement(path) @string)",
    "(include_statement(path) @string)",
    "(comment) @comment",
    '[ "<" ">" "</" "/>" "{{" "}}" "{%" "%}" ] @punctuation.bracket',
  },
  injections = {
    "((expression",
    "(expression_content) @injection.content)",
    '(#set! injection.language "rust"))',
    "((if_statement",
    "(statement_content) @injection.content)",
    '(#set! injection.language "rust"))',
  },
}

local function install_queries()
  local conf_path = vim.fn.stdpath("config")
  local query_path = conf_path .. "/queries/htmlaskama/"
  vim.fn.mkdir(query_path, "p")

  for query_name, content in pairs(queries) do
    local query_file = query_path .. query_name .. ".scm"
    vim.fn.writefile(content, query_file)
  end
end

---@param opts AskamaConfig
function M.setup(opts)
	local path = vim.fn.stdpath("data") .. "/askama/grammar"

	---@diagnostic disable-next-line
	parser_config.htmlaskama = {
		install_info = {
			url = opts.parser_path or "https://github.com/jorismertz/tree-sitter-htmlaskama",
			branch = opts.parser_path and nil or opts.branch,
			files = { "src/parser.c", "src/scanner.c" },
			generate_requires_npm = false,
			requires_generate_from_grammar = false,
		},

		filetype = opts.file_extension,
	}

	install_queries()

	require("nvim-treesitter.configs").setup({
		ensure_installed = "htmlaskama",
		autoinstall = true,
		highlight = {
			enable = true,
		},
	})
end

return M

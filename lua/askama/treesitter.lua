local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

local M = {}

---@param opts AskamaConfig
function M.setup(opts)
	---@diagnostic disable-next-line
	parser_config.htmlaskama = {
		install_info = {
			url = opts.parser_path or "https://github.com/juliamertz/tree-sitter-htmlaskama",
			branch = opts.parser_path and nil or opts.branch,
			files = { "src/parser.c", "src/scanner.c" },
			generate_requires_npm = false,
			requires_generate_from_grammar = false,
		},

		filetype = opts.file_extension,
	}

	require("nvim-treesitter.configs").setup({
		ensure_installed = "htmlaskama",
		autoinstall = true,
		highlight = {
			enable = true,
		},
	})
end

return M

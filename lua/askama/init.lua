local treesitter = require("askama.treesitter")


---@class AskamaConfig
---@field source_file_ext string|string[]|nil
---@field target_filetype string|nil
---@field treesitter_parser string|nil
---@field patterns vim.filetype.mapping|nil

local M = {}

---@type AskamaConfig
M.config = nil

function M._get_defaults()
  local opts = {
    source_file_ext = "html",
    target_filetype = "htmlaskama",
    treesitter_parser = "htmlaskama",
  }

  opts.patterns = {
    [".*/templates/.*%." .. opts.source_file_ext] = opts.target_filetype,
  }
  return opts
end

---@type AskamaConfig
M.defaults = M._get_defaults()

---@private
function M:is_askama()
	local cargo_toml = vim.fn.glob("Cargo.toml")
	return vim.fn.len(cargo_toml) ~= 0
end


---@param opts AskamaConfig
function M:setup(opts)
  opts = vim.tbl_extend("force", M.defaults, opts or {})
  treesitter.setup(opts)

	vim.filetype.add({
		pattern = opts.patterns,
	})

	vim.treesitter.language.register(opts.treesitter_parser, opts.target_filetype)

	-- vim.api.nvim_create_autocmd("BufRead", {
	-- 	pattern = "**/templates/*." .. opts.source_file_ext,
	-- 	callback = function()
	-- 		if M:is_askama() then
	-- 			vim.bo.filetype = opts.target_filetype
	-- 		end
	-- 	end,
	-- })
end

return M



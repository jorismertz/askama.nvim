local treesitter = require("askama.treesitter")


---@class AskamaConfig
---@field source_file_ext string|string[]|nil
---@field target_filetype string|nil
---@field parser_path string|nil
---@field template_dirs string[]|nil

local M = {}

---@type AskamaConfig
M.config = nil

function M._get_defaults()
  local opts = {
    source_file_ext = "html",
    target_filetype = "htmlaskama",
    template_dirs = { "templates" },
    parser_path = nil,
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
  print("askama setup", vim.inspect(opts))
  opts = vim.tbl_extend("force", M.defaults, opts or {})
  treesitter.setup(opts)

  local patterns = { }
  for _, dir in ipairs(opts.template_dirs) do
    patterns[".*/" .. dir .. "/.*%." .. opts.source_file_ext] = opts.target_filetype
  end

  vim.filetype.add({
    pattern = patterns,
  })

  vim.treesitter.language.register("htmlaskama", opts.target_filetype)

  for _, dir in ipairs(opts.template_dirs) do
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "**/" .. dir .. "/**/*." .. opts.source_file_ext,
      callback = function()
        if M:is_askama() then
          vim.bo.filetype = opts.config.target_filetype
        end
      end
    })
  end
end


return M



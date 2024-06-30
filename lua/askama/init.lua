local treesitter = require("askama.treesitter")

---@class AskamaConfig
---@field file_extension string|nil -- What file extension(s) should be targeted
---@field parser_path string|nil -- Different path to the parser for development purposes
---@field template_dirs string[]|nil -- List of directories to look for templates
---@field enable_snippets boolean|nil -- Install luasnip snippets for askama
---@field snippet_autopairs boolean|nil -- Enable this if you are using autopairs to prevent conflicts

local M = {}

M.ns = vim.api.nvim_create_namespace("askama")

---@return AskamaConfig
function M.defaults()
  ---@class AskamaConfig
  local defaults = {
    file_extension = "html",
    template_dirs = { "templates" },
    parser_path = nil,
    enable_snippets = false,
    snippet_autopairs = false,
  }

  return defaults
end

---@type AskamaConfig
M.options = {}

---@private
function M.is_askama()
  local cargo_toml = vim.fn.glob("Cargo.toml")
  return vim.fn.len(cargo_toml) ~= 0
end

---@param opts? AskamaConfig
function M.setup(opts)
  opts = vim.tbl_extend("force", M.defaults(), opts or {})
  treesitter.setup(opts)

  local patterns = { }
  for _, dir in ipairs(opts.template_dirs) do
    patterns[".*/" .. dir .. "/.*%." .. opts.file_extension] = "htmlaskama"
  end

  vim.filetype.add({
    pattern = patterns,
  })

  if opts.enable_snippets then
    require("askama.luasnip").setup(opts)
  end

  vim.treesitter.language.register("htmlaskama", "htmlaskama")

  for _, dir in ipairs(opts.template_dirs) do
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "**/" .. dir .. "/**/*." .. opts.file_extension,
      callback = function()
        if M.is_askama() then
          vim.bo.filetype = "htmlaskama"
        end
      end
    })
  end
end


return M



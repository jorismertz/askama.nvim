local QUERIES = { "class", "highlights", "injections" }
local BRANCH = "stable"
local REPO = "juliamertz/tree-sitter-htmlaskama"

local config_path = vim.fn.stdpath("config")
local query_path = config_path .. "/queries/htmlaskama/"

vim.fn.mkdir(query_path, "p")

for _, query_name in ipairs(QUERIES) do
  local url = "https://raw.githubusercontent.com/" .. REPO .. "/" .. BRANCH .. "/queries/" .. query_name .. ".scm"
  vim.fn.system('curl -LJ "' .. url .. '" > ' .. query_path .. query_name .. ".scm")
end

require('askama.treesitter').setup({
  branch = BRANCH,
})

vim.cmd("TSUpdate htmlaskama")

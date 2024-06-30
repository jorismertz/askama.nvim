local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.snippet

local M = {}

---@param snippets table
---@param lang string|string[]
M.add_snippets = function(snippets, lang)
  local stack = {}
  for _, snippet in pairs(snippets) do
    table.insert(stack, snippet)
  end

  if type(lang) == "table" then
    for _, l in pairs(lang) do
      ls.add_snippets(l, stack)
    end
    return
  else
    ls.add_snippets(lang, stack)
  end
end

-- TODO: Make option to disable/enable autopairs.

---@param autopairs boolean
function M.get_snippets(autopairs)
  local expression_end = autopairs and "" or "}}}}"
  local statement_end = autopairs and "%" or "%}}"

  return {
    expression = s({
        trig = "{%",
        snippetType = "autosnippet"
      },
      fmt("{{% {} " .. statement_end, { i(1) })
    ),
    bracket_spacing = s({
        trig = "{{",
        snippetType = "autosnippet"
      },
      fmt("{{{{ {} " .. expression_end, { i(1) })
    ),

    for_loop = s({ trig = "{% for", },
      fmt([[
        {{% for {} in {} %}}
          {}
        {{% endfor
      ]] .. statement_end, { i(1), i(2), i(3) })
    ),
    include = s({
        trig = "{% include",
        snippetType = "autosnippet"
      },
      fmt('{{% include "{}"' .. statement_end, { i(1) })
    ),
    block = s({ trig = "{% block", },
      fmt([[
        {{% block {} %}}
          {}
        {{% endblock
      ]] .. statement_end, { i(1), i(2) })
    ),
    match = s({ trig = "{% match", },
      fmt([[
        {{% match {} %}}
          {{% when Some with ({}) %}}
            {}
          {{% when None %}}
            {}
        {{% endmatch
      ]] .. statement_end, { i(1), i(2), i(3), i(4) })
    ),
    macro = s({ trig = "{% macro", },
      fmt([[
        {{% macro {}({}) %}}
          {}
        {{% endmacro
      ]] .. statement_end, { i(1), i(2), i(3) })
    ),
    if_statement = s({ trig = "{% if", },
      fmt([[
        {{% if {} %}}
          {}
        {{% else %}}
          {}
        {{% endif
      ]] .. statement_end, { i(1), i(2), i(3) })
    ),
    if_let = s({ trig = "{% if let", },
      fmt([[
        {{% if let Some({}) = {} %}}
          {}
        {{% else %}}
          {}
        {{% endif
      ]] .. statement_end, { i(1), i(2), i(3), i(4) })
    ),
  }
end

---@param opts AskamaConfig
M.setup = function(opts)
  M.add_snippets(M.get_snippets(opts.snippet_autopairs), 'htmlaskama')
end

return M

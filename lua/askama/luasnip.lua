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

local snippets = {
	expression = s({
		trig = "{%",
		snippetType = "autosnippet",
	}, fmt("{{% {} %}}", { i(1) })),
	bracket_spacing = s({
		trig = "{{",
		snippetType = "autosnippet",
	}, fmt("{{{{ {} }}}}", { i(1) })),

	for_loop = s(
		{ trig = "{% for" },
		fmt(
			[[
        {{% for {} in {} %}}
          {}
        {{% endfor %}}
      ]],
			{ i(1), i(2), i(3) }
		)
	),
	include = s({
		trig = "{% include",
		snippetType = "autosnippet",
	}, fmt('{{% include "{}" %}}', { i(1) })),
	block = s(
		{ trig = "{% block" },
		fmt(
			[[
        {{% block {} %}}
          {}
        {{% endblock %}}
      ]],
			{ i(1), i(2) }
		)
	),
	match = s(
		{ trig = "{% match" },
		fmt([[
        {{% match {} %}}
          {{% when Some with ({}) %}}
            {}
          {{% when None %}}
            {}
        {{% endmatch %}}
      ]], { i(1), i(2), i(3), i(4) })
	),
	macro = s(
		{ trig = "{% macro" },
		fmt(
			[[
        {{% macro {}({}) %}}
          {}
        {{% endmacro %}}
      ]],
			{ i(1), i(2), i(3) }
		)
	),
	if_statement = s(
		{ trig = "{% if" },
		fmt(
			[[
        {{% if {} %}}
          {}
        {{% else %}}
          {}
        {{% endif %}}
      ]],
			{ i(1), i(2), i(3) }
		)
	),
	if_let = s(
		{ trig = "{% if let" },
		fmt(
			[[
        {{% if let Some({}) = {} %}}
          {}
        {{% else %}}
          {}
        {{% endif %}}
      ]],
			{ i(1), i(2), i(3), i(4) }
		)
	),
}

M.setup = function()
	M.add_snippets(snippets, "htmlaskama")
end

return M

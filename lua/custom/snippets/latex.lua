local ls = require('luasnip')  -- Load the luasnip module
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local i = ls.insert_node


ls.add_snippets('tex', {
  s('document', fmt([[
  hello world
  ]],
  {}))
})

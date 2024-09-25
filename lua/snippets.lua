local ls = require('luasnip')  -- Require the luasnip module
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Define a simple snippet for a 'for' loop in Python
ls.add_snippets('python', {
  s('docstr', {
    t('\'\'\''),
    i(1, 'Description'),
    t({'', '', 'Argument(s)'}),
    t({'', '-----------'}),
    t({'', ''}),
    i(2, 'argument1'),
    t(' -- '),
    i(3, 'description1'),
    t(''),
    t({'', 'Returns'}),
    t({'', '-----------'}),
    t({'', ''}),
    i(4, 'return1'),
    t(' -- '),
    i(5, 'ret_description1'),
    t({''}),
    t('\'\'\''),
  })
})


local ls = require('luasnip')  -- Load the luasnip module
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local i = ls.insert_node

-- Define a snippet for a Python docstring template using fmt
ls.add_snippets('python', {
  s('docstr', fmt([[
    '''
    {}
    
    Argument(s)
    -----------
    {} -- {}

    Returns
    -----------
    {} -- {}
    '''
  ]], {
    i(1, 'Description'),       -- Placeholder for the description
    i(2, 'argument1'),         -- Placeholder for the argument name
    i(3, 'description1'),      -- Placeholder for the argument description
    i(4, 'return1'),           -- Placeholder for the return value
    i(5, 'ret_description1')   -- Placeholder for the return description
  }))
})

ls.add_snippets('python', {
  s('dpara', fmt([[
{} -- {}
  ]],{
    i(1, 'param'),
    i(2, 'description')
  }))
})

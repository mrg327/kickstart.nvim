local ls = require('luasnip')  -- Load the luasnip module
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local i = ls.insert_node

-- Define a snippet for a Python docstring template using fmt
ls.add_snippets('python', {
  s('docstr', fmt([[
    """
    {}
    
    Args:
        {} ({}): {}

    Returns:
        {} ({}): {}
    """
  ]], {
    i(1, 'Definition'),        -- Placeholder for the description
    i(2, 'Argument'),          -- Placeholder for the argument name
    i(3, 'Argument Type'),     -- Placeholder for the argument name
    i(4, 'Description'),       -- Placeholder for the argument description
    i(5, 'Return'),            -- Placeholder for the return value
    i(6, 'Return Type'),       -- Placeholder for the return value
    i(7, 'Return Description') -- Placeholder for the return description
  }))
})

ls.add_snippets('python', {
  s('dpara', fmt([[
  {} ({}): {}
  ]],{
    i(1, 'Param'),
    i(2, 'Param Type'),
    i(3, 'Param Description')
  }))
})

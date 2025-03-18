local ls = require('luasnip')  -- Load the luasnip module
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('cucumber', {
  s('dscenario', fmt([[
    @{}
    Scenario: {}
    Given {}
    When {}
    Then {}
  ]], {
    i(1, '<pytest-mark>'),        -- Placeholder for the description
    i(2, '<scenario-id>'),     -- Placeholder for the argument name
    i(3, '<given-text>'),       -- Placeholder for the argument description
    i(4, '<when-text>'),            -- Placeholder for the return value
    i(5, '<then-text>'),       -- Placeholder for the return value
  }))
})


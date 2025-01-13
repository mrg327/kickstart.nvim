local ls = require('luasnip')  -- Load the luasnip module
local fmt = require('luasnip.extras.fmt').fmt
local s = ls.snippet
local i = ls.insert_node

ls.add_snippets('lua', {
  s(
    'love2d',
    fmt(
      [[
  local love = require("love")

  -- game states
  Gamestate = require("hump.gamestate")
  require("lib.states.game")

  function love.load()
          love.graphics.setIcon(love.graphics.newImage("media/images/icon.png"))
          love.graphics.setCaption("GAME NAME")
          love.graphics.setMode(1024, 768, false, true, 0)

          -- will switch to the game gamestate, you could start
          -- with the intro or main menu here
          Gamestate.switch(game)
  end

  function love.update(dt)
          Gamestate.update(dt)
  end

  function love.keypressed(key)
          Gamestate.keypressed(key, code)
  end

  function love.draw()
          Gamestate.draw()
  end
  ]],
      {}
    )
  ),
})

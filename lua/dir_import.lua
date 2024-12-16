--[[
This will tell git you want to start ignoring the changes to the file
git update-index --assume-unchanged plua/dir_import.lua

When you want to start keeping track again
git update-index --no-assume-unchanged lua/dir_import.lua
--]]

local configs = { pyright = '/Users/matthewghere/npm/pyright-langserver', python = '/Users/matthewghere/.venv/bin/python', shell = 'powershell.exe' }

return configs

--[[
This will tell git you want to start ignoring the changes to the file
git update-index --assume-unchanged plua/dir_import.lua

When you want to start keeping track again
git update-index --no-assume-unchanged lua/dir_import.lua
--]]

local configs =
  { pyright = 'C:/Users/Owner/AppData/Roaming/npm/pyright-langserver', python = 'C:/Users/Owner/.venv/Scripts/python.exe', shell = 'powershell.exe' }

return configs

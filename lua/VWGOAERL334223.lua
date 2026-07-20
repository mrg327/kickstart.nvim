--[[
This will tell git you want to start ignoring the changes to the file
git update-index --assume-unchanged plua/dir_import.lua

When you want to start keeping track again
git update-index --no-assume-unchanged lua/dir_import.lua
--]]

local configs = {
  python = 'C:/Users/dvuhpqu.US/.venv/Scripts/python.exe',
  shell = 'powershell.exe',
  llm_addr = 'ppe-tlab216:11434',
}

return configs

--[[
This will tell git you want to start ignoring the changes to the file
git update-index --assume-unchanged path/to/file

When you want to start keeping track again
git update-index --no-assume-unchanged path/to/file
--]]


local configs = {pyright = "/Users/matthewghere/npm/pyright-langserver",
                 python = "/Users/matthewghere/.venv/bin/python"}

return configs

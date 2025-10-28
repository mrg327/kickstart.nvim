print("Hello from present.lua")

local M = {}

M.setup = function ()
end

---@class present.Slides
---@field slides string[]: The slides of the file

-- Takes some liens and parses them 
---@param lines string[]: The lines of the file
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  for _, line in ipairs(lines) do
    print(line)
  end
end 
return M

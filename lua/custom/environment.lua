local M = {}

local function hostname()
  local name = os.getenv('COMPUTERNAME') or os.getenv('HOSTNAME')
  if name and name ~= '' then
    return name
  end

  local handle = io.popen('hostname')
  if not handle then
    return 'default'
  end
  name = handle:read('*l')
  handle:close()
  return name and name ~= '' and name or 'default'
end

function M.get()
  local name = hostname()
  for _, module in ipairs({ name:gsub('[^%w_]', '_'), name }) do
    local ok, config = pcall(require, module)
    if ok and type(config) == 'table' then
      return config
    end
  end
  return require('default')
end

return M

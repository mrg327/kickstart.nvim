local M = {}

local root_markers = {
  'pyproject.toml',
  'uv.lock',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  '.git',
}

--- Find the project root for a given path (defaults to the current buffer).
function M.root(start)
  return vim.fs.root(start or 0, root_markers)
end

--- Return the interpreter inside a virtual-environment directory, if present.
local function interpreter(venv_dir)
  local candidates = {
    venv_dir .. '/bin/python',
    venv_dir .. '/bin/python3',
    venv_dir .. '/Scripts/python.exe',
  }
  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
  return nil
end

--- Resolve the project Python interpreter.
--- Order of preference:
---   1. An already-activated environment ($VIRTUAL_ENV).
---   2. The nearest `.venv`/`venv` searching UPWARD from `start`. Walking up is
---      required for uv workspaces, where members share a single `.venv` at the
---      workspace root (a parent directory).
function M.python(start)
  local active = vim.env.VIRTUAL_ENV
  if active and active ~= '' then
    local python = interpreter(active)
    if python then
      return python
    end
  end

  local from = start
  if from == nil or from == '' then
    from = vim.fn.expand '%:p:h'
  end
  if from == nil or from == '' then
    from = vim.uv.cwd()
  end

  -- Nearest match first, then progressively higher ancestors.
  local found = vim.fs.find({ '.venv', 'venv' }, {
    upward = true,
    path = from,
    type = 'directory',
    limit = math.huge,
  })
  for _, venv_dir in ipairs(found) do
    local python = interpreter(venv_dir)
    if python then
      return python
    end
  end

  return nil
end

return M

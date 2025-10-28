local M = {}

local function create_floating_window(config, enter)
  if enter == nil then
    enter = false
  end
  
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, config)
  
  return { buf = buf, win = win }
end

M.setup = function()
end

---@class present.Slides
---@field slides string[][]: The slides of the file

-- Takes some lines and parses them
---@param lines string[]: The lines of the file
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local current_slide = {}
  local separator = "^#"
  
  for _, line in ipairs(lines) do
    if line:find(separator) then
      if #current_slide > 0 then
        table.insert(slides.slides, current_slide)
      end
      current_slide = {}
    end
    table.insert(current_slide, line)
  end
  table.insert(slides.slides, current_slide)
  return slides
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  
  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  local parsed = parse_slides(lines)
  
  -- Create floating window with proper config
  local width = math.floor(vim.o.columns)
  local height = math.floor(vim.o.lines)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  local config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
  }
  
  local float = create_floating_window(config, true)

  local current_slide = 1
  vim.keymap.set('n', 'n', function()
    current_slide = math.min(current_slide + 1, #parsed.slides)
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
  end,{ buffer = float.buf, })

  vim.keymap.set('n', 'p', function()
    current_slide = math.max(current_slide - 1, 1)
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
  end, { buffer = float.buf, })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(float.win, true)
  end, { buffer = float.buf, })
  
  -- Display first slide (or implement navigation)
  if #parsed.slides > 0 then
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1])
  end
  
  -- TODO: Add keymaps for navigation between slides
  -- TODO: Store state for current slide index
end

M.start_presentation {bufnr = 21}

return M

-- Copilot Utilities for Agentic Coding Workflow
local M = {}

-- Function to apply Copilot chat suggestions more easily
function M.apply_copilot_suggestion()
  -- Get the current buffer content
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- Look for code blocks in the chat (typically marked with ```language)
  local code_blocks = {}
  for line in content:gmatch('[^\r\n]+') do
    if line:match('^```%w+') then
      -- Found a code block start
      local lang = line:match('^```(%w+)')
      local start_line = vim.api.nvim_win_get_cursor(0)[1]
      -- Find the end of the code block
      for i = start_line + 1, #lines do
        if lines[i]:match('^```$') then
          -- Extract the code block
          local code_lines = {}
          for j = start_line + 1, i - 1 do
            table.insert(code_lines, lines[j])
          end
          table.insert(code_blocks, {
            language = lang,
            lines = code_lines,
            start_line = start_line,
            end_line = i
          })
          break
        end
      end
    end
  end

  if #code_blocks > 0 then
    -- For now, just yank the first code block to register
    local code = table.concat(code_blocks[1].lines, '\n')
    vim.fn.setreg('"', code)
    vim.notify('Code copied to clipboard. Use p to paste.', vim.log.levels.INFO)
  else
    vim.notify('No code blocks found in chat', vim.log.levels.WARN)
  end
end

-- Function to replace selected text with Copilot suggestion
function M.replace_with_copilot()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  if start_pos[2] == 0 or end_pos[2] == 0 then
    vim.notify('No text selected', vim.log.levels.WARN)
    return
  end

  -- Get the current buffer content
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- Look for code blocks (simple approach - take the last code block)
  local last_code_block = nil
  local in_code_block = false
  local code_lines = {}

  for line in content:gmatch('[^\r\n]+') do
    if line:match('^```%w+') and not in_code_block then
      in_code_block = true
      code_lines = {}
    elseif line:match('^```$') and in_code_block then
      in_code_block = false
      last_code_block = code_lines
    elseif in_code_block then
      table.insert(code_lines, line)
    end
  end

  if last_code_block and #last_code_block > 0 then
    -- Replace the selected text with the code block
    local replacement = table.concat(last_code_block, '\n')
    vim.api.nvim_buf_set_text(bufnr, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3], vim.split(replacement, '\n'))
    vim.notify('Code replaced successfully', vim.log.levels.INFO)
  else
    vim.notify('No code blocks found to replace with', vim.log.levels.WARN)
  end
end

-- Quick agentic actions
function M.refactor_current_function()
  vim.cmd('CopilotChat refactor this function')
end

function M.improve_current_function()
  vim.cmd('CopilotChat improve this function')
end

function M.add_type_hints()
  vim.cmd('CopilotChat add type hints to this function')
end

-- Function to create a floating window for quick Copilot commands
function M.quick_copilot_command()
  local commands = {
    'Refactor this code',
    'Improve this function',
    'Add error handling',
    'Convert to async',
    'Add type hints',
    'Optimize performance',
    'Add documentation',
    'Write tests for this',
    'Fix this bug',
    'Convert to different paradigm',
  }

  vim.ui.select(commands, {
    prompt = 'Select Copilot action:',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice then
      vim.cmd('CopilotChat ' .. choice:lower())
    end
  end)
end

return M

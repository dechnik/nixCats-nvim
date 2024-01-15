if nixCats('nixCats_packageName') ~= "minimal" then
  if nixCats('AI') then
    local bitwardenAuth = false
    local codeiumDir = vim.fn.stdpath('cache') .. '/' .. 'codeium'
    local codeiumAuthFile = codeiumDir .. '/' .. 'config.json'
    if (vim.fn.expand("$SRC_ACCESS_TOKEN") == "$SRC_ACCESS_TOKEN") then
      local tokenPath = vim.fn.expand("$HOME") .. "/.secrets/codyToken"
      if (vim.fn.filereadable(tokenPath) == 1) then
        local result
        local handle
        handle = io.open(tokenPath, "r")
        if handle then
          result = handle:read("*l")
          handle:close()
        end
        local endpoint = 'https://sourcegraph.com'
        local token = result
        require('sg.auth').set(endpoint, token)
      end
    end
    require("sg").setup({
      on_attach = require("myLuaConf.LSPs.caps-onattach").on_attach,
      enable_cody = true,
    })
    vim.keymap.set('n', '<leader>cs', require('sg.extensions.telescope').fuzzy_search_results, { noremap = true, desc = 'cody search' })
    vim.keymap.set('n', '<leader>cc', [[<cmd>CodyToggle<CR>]], { noremap = true, desc = 'CodyChat' })
    vim.keymap.set('v', '<leader>cc', [[:CodyAsk ]], { noremap = true, desc = 'CodyAsk' })
    if vim.fn.filereadable(codeiumAuthFile) == 0 then
      local keyPath = vim.fn.expand("$HOME") .. "/.secrets/codeiumToken"
      if (vim.fn.filereadable(keyPath) == 1) then
        local result
        local handle
        handle = io.open(keyPath, "r")
        if handle then
          result = handle:read("*l")
          handle:close()
        end
        if vim.fn.isdirectory(codeiumDir) == 0 then
          -- Directory does not exist, so create it
          vim.fn.mkdir(codeiumDir, 'p')
        end
        if (string.len(result) == 36) then
          -- Open the file in write mode
          local file = io.open(codeiumAuthFile, 'w')
          -- Check if the file was successfully opened
          if file then
            file:write('{"api_key": "' .. result .. '"}')
            file:close()
          end
        end
      end
    end

    vim.cmd([[command! ClearSGAuth lua require("birdee.utils").deleteFileIfExists(vim.fn.stdpath('data') .. '/cody.json')]])
    vim.cmd([[command! ClearCodeiumAuth lua require("birdee.utils").deleteFileIfExists(vim.fn.stdpath('cache') .. '/codeium/config.json')]])
  end
end

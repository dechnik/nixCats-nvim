if nixCats('nixCats_packageName') ~= "minimal" then
  if nixCats('AI') then
    require("sg").setup({
      on_attach = require("myLuaConf.LSPs.caps-onattach").on_attach,
      enable_cody = true,
    })
    vim.keymap.set('n', '<leader>cs', require('sg.extensions.telescope').fuzzy_search_results, { noremap = true, desc = 'cody search' })
    vim.keymap.set('n', '<leader>cc', [[<cmd>CodyToggle<CR>]], { noremap = true, desc = 'CodyChat' })
    vim.keymap.set('v', '<leader>cc', [[:CodyAsk ]], { noremap = true, desc = 'CodyAsk' })
  end
end
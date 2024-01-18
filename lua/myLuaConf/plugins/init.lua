local colorschemeName = nixCats('colorscheme')
if require('nixCatsUtils').isNixCats then
  colorschemeName = 'gruvbox'
end
vim.cmd.colorscheme(colorschemeName)

require('myLuaConf.plugins.telescope')

require('myLuaConf.plugins.treesitter')

require('myLuaConf.plugins.completion')

if nixCats('markdown') then
  vim.g.mkdp_auto_close = 0
  vim.keymap.set('n','<leader>mp','<cmd>MarkdownPreview <CR>',{ noremap = true, desc = 'markdown preview' })
  vim.keymap.set('n','<leader>ms','<cmd>MarkdownPreviewStop <CR>',{ noremap = true, desc = 'markdown preview stop' })
  vim.keymap.set('n','<leader>mt','<cmd>MarkdownPreviewToggle <CR>',{ noremap = true, desc = 'markdown preview toggle' })
end

vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })
vim.g.undotree_WindowLayout = 1
vim.g.undotree_SplitWidth = 40

require('hlargs').setup({
  color = '#32a88f',
})
require('Comment').setup()
require('fidget').setup()
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = colorschemeName,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_c = {
      {
        'filename', path = 1, status = true,
      },
    },
  },
})
require('nvim-surround').setup()

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({})
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { noremap = true, silent = true, desc = 'append to harpoon' })
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true, silent = true, desc = 'open harpoon menu' })

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { noremap = true, silent = true, desc = 'harpoon 1' })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { noremap = true, silent = true, desc = 'harpoon 2' })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { noremap = true, silent = true, desc = 'harpoon 3' })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { noremap = true, silent = true, desc = 'harpoon 4' })

-- indent-blank-line
require("ibl").setup()

-- I honestly only use this to see the little git icons.
-- I wanna figure out how to add them to netrw instead and ditch this
require('neo-tree').setup({
  close_if_last_window = true,
  window = {
    position = "float",
    mappings = {
      ["<space>"] = {
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        noremap = false,
      },
    },
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true,
    },
    hijack_netrw_behavior = "disabled",
  },
  buffers = {
    follow_current_file = {
      enabled = true,
    },
  },
})
vim.keymap.set("n", "<leader>FT", "<cmd>Neotree toggle<CR>", { noremap = true, desc = '[F]ile [T]ree' })

local obsidian = require("obsidian")
obsidian.setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Documents/Obsidian/Personal",
    },
    {
      name = "work",
      path = "~/Documents/Obsidian/Work",
    },
  },
})

vim.keymap.set('n','<leader>os','<cmd>ObsidianSearch <CR>',{ noremap = true, desc = '[O]bsidian [S]earch' })
vim.keymap.set('n','<leader>on','<cmd>ObsidianNew <CR>',{ noremap = true, desc = '[O]bsidian [N]ew' })
vim.keymap.set('n','<leader>ol','<cmd>ObsidianLink <CR>',{ noremap = true, desc = '[O]bsidian [L]ink' })
vim.keymap.set('n','<leader>ot','<cmd>ObsidianTemplate <CR>',{ noremap = true, desc = '[O]bsidian [T]emplate' })
vim.keymap.set('n','<leader>of','<cmd>ObsidianFollowLink <CR>',{ noremap = true, desc = '[O]bsidian [F]ollow Link' })

require('gitsigns').setup({
    -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk,
        { buffer = bufnr, desc = 'Preview git hunk' })

    -- don't override the built-in and fugitive keymaps
    local gs = package.loaded.gitsigns
    vim.keymap.set({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
    vim.keymap.set({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
  end,
})
vim.cmd([[hi GitSignsAdd guifg=#04de21]])
vim.cmd([[hi GitSignsChange guifg=#83fce6]])
vim.cmd([[hi GitSignsDelete guifg=#fa2525]])

require('which-key').setup()

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ody', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = '[M]arkdown', _ = 'which_key_ignore' },
  ['<leader>F'] = { name = '[F]ile explorer', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
  ['<leader>o'] = { name = '[O]bsidian', _ = 'which_key_ignore' },
}

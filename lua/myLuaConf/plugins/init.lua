local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
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

require('hlargs').setup {
  color = '#32a88f',
}
vim.cmd([[hi clear @lsp.type.parameter]])
vim.cmd([[hi link @lsp.type.parameter Hlargs]])
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

require'alpha'.setup(require'alpha.themes.startify'.config)

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

local obsidian = require("obsidian")
obsidian.setup({
  workspaces = {
    {
      name = "vault",
      path = "~/Documents/Obsidian",
    },
  },
  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "Daily",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = nil
  },
  templates = {
    subdir = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- A map for custom variables, the key should be the variable and the value a function
    substitutions = {},
  },
  ui = {
    enable = false,  -- set to false to disable all additional syntax features
    update_debounce = 200,  -- update delay after a text change (in milliseconds)
    -- Define how various check-boxes are displayed
    checkboxes = {
      -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      -- Replace the above with this if you don't have a patched font:
      -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
      -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

      -- You can also add more custom ones...
    },
    -- Use bullet marks for non-checkbox lists.
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    -- Replace the above with this if you don't have a patched font:
    -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    hl_groups = {
      -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
      ObsidianTodo = { bold = true, fg = "#d65d0e" },
      ObsidianDone = { bold = true, fg = "#458588" },
      ObsidianRightArrow = { bold = true, fg = "#d65d0e" },
      ObsidianTilde = { bold = true, fg = "#cc241d" },
      ObsidianBullet = { bold = true, fg = "#458588" },
      ObsidianRefText = { underline = true, fg = "#b16286" },
      ObsidianExtLinkIcon = { fg = "#b16286" },
      ObsidianTag = { italic = true, fg = "#458588" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },
})

vim.keymap.set('n','<leader>os','<cmd>ObsidianSearch <CR>',{ noremap = true, desc = '[O]bsidian [S]earch' })
vim.keymap.set('n','<leader>on','<cmd>ObsidianNew <CR>',{ noremap = true, desc = '[O]bsidian [N]ew' })
vim.keymap.set('n','<leader>ol','<cmd>ObsidianLink <CR>',{ noremap = true, desc = '[O]bsidian [L]ink' })
vim.keymap.set('n','<leader>oe','<cmd>ObsidianLinkNew <CR>',{ noremap = true, desc = '[O]bsidian Link [N]ew' })
vim.keymap.set('n','<leader>ot','<cmd>ObsidianTags <CR>',{ noremap = true, desc = '[O]bsidian [T]ags' })
vim.keymap.set('n','<leader>of','<cmd>ObsidianFollowLink <CR>',{ noremap = true, desc = '[O]bsidian [F]ollow Link' })

-- indent-blank-line
require("ibl").setup()

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
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to next hunk' })

    map({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to previous hunk' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'stage git hunk' })
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'reset git hunk' })
    -- normal mode
    map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
    map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
    map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
    map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
    map('n', '<leader>gb', function()
      gs.blame_line { full = false }
    end, { desc = 'git blame line' })
    map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>gD', function()
      gs.diffthis '~'
    end, { desc = 'git diff against last commit' })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
  end,
})
vim.cmd([[hi GitSignsAdd guifg=#04de21]])
vim.cmd([[hi GitSignsChange guifg=#83fce6]])
vim.cmd([[hi GitSignsDelete guifg=#fa2525]])

require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    -- "mtime",
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",

    -- Which-key does not like this keybind AT ALL
    -- ["g\\"] = "actions.toggle_trash",
    ["g!"] = "actions.toggle_trash",
    ["g\\"] = false,
  },
})
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = 'Open Parent Directory' })
vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = 'Open nvim root directory' })
-- Which key has kind-of a lot of bugs.
-- Nix or not, some things need to be disabled.
require('which-key').setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    -- BUGGED registers plugin
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      -- BUGGED window control keys display
      windows = false, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  operators = { gc = "Comments", [ "<leader>y" ] = "yank to clipboard", },
  disable = {
    -- filetypes = { "oil" },
  },
})
local neogit = require("neogit")
neogit.setup {
  integrations = {
    diffview = true,
  },
}

vim.keymap.set('n','<leader>gg','<cmd>Neogit <CR>',{ noremap = true, desc = '[g]it neo[g]it' })

-- I had these errors before nixos, but I fixed them in a dumb way.
-- I simply bound them again myself and it mostly worked...
-- this is the better way to prevent the errors.

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[c]ode, [c]ody', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = '[h]arpoon', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[w]orkspace', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = '[m]arkdown', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[t]oggles', _ = 'which_key_ignore' },
  ['<leader>o'] = { name = '[o]bsidian', _ = 'which_key_ignore' },
}

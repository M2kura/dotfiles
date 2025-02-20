-- [[ Setting options ]]
-- See `:help vim.opt`

local opt = vim.opt

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = 'a'

-- Don't show mode since we have a statusline
opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters
opt.list = true
opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
opt.inccommand = 'split'

-- Show cursor line
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

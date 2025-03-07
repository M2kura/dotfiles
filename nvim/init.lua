-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- Load the rest of your Neovim configuration
require 'config.options'
require 'config.lazy'
require 'config.autocmds'
require 'config.keymaps'

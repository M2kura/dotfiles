return {
  {
    'nvimdev/indentmini.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('indentmini').setup {
        char = '│',
        exclude = {
          'help',
          'dashboard',
          'lazy',
          'mason',
          'terminal',
          'prompt',
        },
        -- Only show guide for the current indentation level
        only_current = false,
        -- Minimum indentation level to show guides
        minlevel = 1,
      }

      -- Set indentation guide colors
      vim.cmd.highlight 'IndentLine guifg=#3b4261'
      vim.cmd.highlight 'IndentLineCurrent guifg=#7aa2f7'
    end,
  },
}

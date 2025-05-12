return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'zbirenbaum/copilot.lua',
    },
    opts = {
      model = 'gpt-4',
      window = {
        title = 'Copilot Chat',
      },
    },
    keys = {
      {
        '<leader>cc',
        ':CopilotChatToggle<CR>',
        desc = 'Toggle Copilot Chat',
        mode = 'n',
      },
      {
        '<leader>ce',
        ':CopilotChatExplain<CR>',
        desc = 'Copilot Chat Explain',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cr',
        ':CopilotChatReview<CR>',
        desc = 'Copilot Chat Review',
        mode = { 'n', 'v' },
      },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)
    end,
  },
}

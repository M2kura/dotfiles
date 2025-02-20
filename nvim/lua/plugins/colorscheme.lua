return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      require('kanagawa').setup {
        transparent = true,
        theme = 'dragon',
        background = {
          dark = 'dragon',
          light = 'lotus',
        },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
}

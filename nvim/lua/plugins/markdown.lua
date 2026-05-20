return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'markdown.mdx', 'Avante' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
  opts = {
    sign = { enabled = false },
    code = {
      -- general
      width = 'block',
      min_width = 80,
      -- borders
      border = 'thin',
      left_pad = 1,
      right_pad = 1,
      -- language info
      position = 'right',
      language_icon = true,
      language_name = true,
      -- avoid making headings ugly
      highlight_inline = 'RenderMarkdownCodeInfo',
    },
    completions = {
      blink = { enabled = true },
      lsp = { enabled = true },
    },
    pipe_table = {
      alignment_indicator = '─',
      border = { '╭', '┬', '╮', '├', '┼', '┤', '╰', '┴', '╯', '│', '─' },
    },
  },
}

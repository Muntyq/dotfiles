vim.pack.add({ { src = 'https://github.com/rebelot/kanagawa.nvim' }, })
vim.cmd.colorscheme('kanagawa-wave')

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

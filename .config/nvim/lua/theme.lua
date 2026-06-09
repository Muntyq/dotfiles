vim.pack.add({ { src = 'https://github.com/rebelot/kanagawa.nvim' }, })
vim.cmd.colorscheme('kanagawa-wave')

-- Rm background alien thingy
local function clear_bg(group)
     local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
     hl.bg = nil
     hl.ctermbg = nil
     vim.api.nvim_set_hl(0, group, hl)
end

local groups = {
     "Normal", "NormalNC", "NormalFloat",
     "SignColumn", "EndOfBuffer",
}

for _, g in ipairs(groups) do
     clear_bg(g)
end

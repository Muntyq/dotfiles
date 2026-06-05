local map = function(mode, whatkey, whatdoes, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, whatkey, whatdoes, opts)
end

-- Set <leader> key ------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Leave doc --------------------------------------
map("n", "<leader>pv", vim.cmd.Ex)

-- Windows ---------------------------------------
local modes = { 'n', 'i', 't', 'v' }
for _, mode in ipairs(modes) do
	vim.keymap.set(mode, '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window' })
	vim.keymap.set(mode, '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to bottom window' })
	vim.keymap.set(mode, '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to top window' })
	vim.keymap.set(mode, '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window' })
end

-- Resize ---------
map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>")

-- Create/Close ---
local function smart_split()
	local window = vim.api.nvim_get_current_win()
	local window_width = vim.api.nvim_win_get_width(window)
	local window_height = vim.api.nvim_win_get_height(window)

	if window_width > window_height * 2 then
		vim.cmd('vsplit')
	else
		vim.cmd('split')
	end
end

map('n', '<C-n>', smart_split, { desc = "Open new window" })
map("n", "<C-c>", "<C-w>c", { desc = "Close window" })

-- Buffers ---------------------------------------
map("n", "<M-Tab>", "<cmd>bnext<cr>")
map("n", "<M-S-Tab>", "<cmd>bprevious<cr>")
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>c", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Clear search highlight ------------------------
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Visual mode indenting -------------------------
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Visual mode move lines ------------------------
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- Paste over selection without yanking it -------
map("v", "p", '"_dP')

-- Delete without yanking ------------------------
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })

-- Leader + save/quit/!quit ----------------------
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qall!<cr>", { desc = "Quit all" })

-- Better escape in terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Diagnostics (to test)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Group to avoid duplicates -----------------------------------------
local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank -------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- Highlight current window ------------------------------------------
vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
	group = augroup("active_window_border"),
	callback = function(ev)
		if ev.event == "WinEnter" then
			vim.wo.winhighlight = "Normal:Normal,NormalNC:Normal"
		else
			vim.wo.winhighlight = "Normal:NormalNC"
		end
	end,
})

-- Rm trailing whitespace on save ------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("trim_whitespace"),
	callback = function()
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, pos)
	end,
})

vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1a1a1a" })

-- Restore cursor position -------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("restore_cursor"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- Close specific buffers with q only -------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "man", "qf", "checkhealth", "lspinfo", "notify" },
	callback = function(ev)
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
	end,
})

-- //to test Resize windows and terminal
-- vim.api.nvim_create_autocmd("VimResized", {
-- 	group = augroup("resize_splits"),
-- 	callback = function() vim.cmd("tabdo wincmd =") end,
-- })

-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	group = augroup("terminal_settings"),
-- 	callback = function()
-- 		vim.opt_local.number = false
-- 		vim.opt_local.relativenumber = false
-- 		vim.opt_local.signcolumn = "no"
-- 	vim.cmd("startinsert")
-- 	end,
-- })

--Bootstrap lazy.nvim
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git" , "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim", lazypath })
end

vim.opt.rtp:prepend(lazypath)

--Require files
--

require("inaVim")

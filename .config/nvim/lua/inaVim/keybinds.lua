vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--Remap hjkl -> jkl;
--
--vim.keymap.set({"n","v"}, "j", "h")
--vim.keymap.set({"n","v"}, "k", "j")
--vim.keymap.set({"n","v"}, "l", "k")
--vim.keymap.set({"n","v"}, ";", "l")


vim.keymap.set({"n","v","i"}, "<Up>", "<Nop>")
vim.keymap.set({"n","v","i"}, "<Down>", "<Nop>")
vim.keymap.set({"n","v","i"}, "<Left>", "<Nop>")
vim.keymap.set({"n","v","i"}, "<Right>", "<Nop>")

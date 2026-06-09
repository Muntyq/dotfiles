local opt = vim.opt

-- Ui ------------------
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.inccommand = "split"
opt.termguicolors = true
opt.showmode = true
opt.cmdheight = 1

-- Text behaviour ------
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.wrap = true
opt.tabstop = 8      -- default
opt.shiftwidth = 4   -- actual indent
opt.softtabstop = -1 -- follow shiftwidth
opt.expandtab = true --use spaces, not tabs
opt.smartindent = true
opt.breakindent = true
opt.autoindent = true
opt.list = true
opt.listchars = { tab = '› ', trail = '·', nbsp = '␣' } --'› ''» '

-- Tmux ----------------
opt.splitright = true
--opt.splitbelow = true

-- Files ---------------
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Search --------------
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Folding (treesitter)-
-- opt.foldmethod = "expr"
-- opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- opt.foldlevel = 99            -- open all folds by default

-- Misc ----------------
opt.mouse = "a"
opt.pumheight = 10                            --popup menu heigh
opt.completeopt = "menuone,noinsert,noselect" --auto complete things if using nvim-cmp probably use menu,menuone
opt.shortmess:append("c")                     --search info, its about ignoring info
opt.confirm = true

vim.schedule(function() opt.clipboard = "unnamedplus" end)

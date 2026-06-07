vim.pack.add({ { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' }, })

local blink = require('blink.cmp')

blink.setup({
	-- Pure Lua fuzzy matcher — no Rust binary needed, works fine on NixOS
	fuzzy = { implementation = 'lua' },

	keymap = {
		preset        = 'none', -- we define everything explicitly

		-- ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		-- ['<C-e>']     = { 'hide', 'fallback' },

		-- Manual navigation
		['<Tab>']     = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>']   = { 'select_prev', 'snippet_backward', 'fallback' },
		['<C-Space>'] = { 'select_and_accept', 'fallback' },

		-- Tab: accept item OR jump to next snippet placeholder
		-- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

		-- Scroll docs popup
		-- ['<C-d>']     = { 'scroll_documentation_down', 'fallback' },
		-- ['<C-u>']     = { 'scroll_documentation_up',   'fallback' },
	},

	completion = {
		-- Only show docs when manually requested (C-Space again while menu is open)
		documentation = {
			auto_show = true,
			window    = { border = 'none' },
		},
		menu = {
			border = 'none',
			winblend = 15, -- opacity, 0 = opaque; 100 = invisible
			-- Show a little type annotation column on the right
			draw = {
				columns = {
					{ 'label',     'label_description', gap = 1 },
					{ 'kind_icon', 'kind',              gap = 1 },
				},
			},
		},

		-- Don't auto-select or auto-insert — wait for explicit Tab/C-n
		list = {
			selection = {
				preselect   = false,
				auto_insert = false,
			},
		},
	},

	-- Signature help popup while typing function args
	signature = {
		enabled = true,
		window = { border = 'none' },
	},

	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	},

	-- Native vim.snippet support
	snippets = { preset = 'default' },

	appearance = {
		nerd_font_variant = 'mono',
	},
})
vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = 'NONE', reverse = true })

-- LSP Language Servers -------------------------------------------------------------

vim.lsp.enable({ 'rust_analyzer', 'lua_ls', 'bashls', 'gopls' })

-- Rust
vim.lsp.config('rust_analyzer', {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
	settings = {
		['rust-analyzer'] = {
			checkOnSave = { command = 'clippy' },
		},
	},
})

-- Lua
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('', true),
			},
			diagnostics = { globals = { 'vim' } },
			telemetry = { enable = false },
		},
	},
})

-- Bash
vim.lsp.config('bashls', {
	cmd = { 'bash-language-server', 'start' },
	filetypes = { 'sh', 'bash' },
	root_markers = { '.git' },
})

-- Go
vim.lsp.config('gopls', {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	root_markers = { 'go.work', 'go.mod', '.git' },
	settings = {
		gopls = {
			analyses    = { unusedparams = true },
			staticcheck = true,
		},
	},
})

-- LSP AUTOCOMANDS AUTOCMD -----------------------------------------------------

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP keybinds',
	callback = function(ev)
		local map = function(mode, whatkey, whatdoes, desc)
			vim.keymap.set(mode, whatkey, whatdoes, { buffer = ev.buf, silent = true, desc = desc })
		end

		-- Navigation
		map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
		map('n', 'gD', vim.lsp.buf.declaration, 'Goto declatation')
		map('n', 'gr', vim.lsp.buf.references, 'List all references')    -- List all references
		map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation') -- Jump to implementation
		map('n', 'K', vim.lsp.buf.hover, 'Show hover docs')              -- Hover docs in a float
		map('n', '<C-k>', vim.lsp.buf.signature_help, 'Show function signature') -- Show function signature when mouse is inside args

		map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
		map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code actions')


		-- Diagnostics
		map('n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic')
		map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
		map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')
	end,
})

-- Auto formatinc on save
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*',
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

-- Diagnosis ---------------------------------------------------
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- configs for specific lsp server
--
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
	capabilities = capabilities,
})
vim.lsp.config('lua_ls', {
	settings = { Lua = { diagnostics = { globals = { 'vim' }}}}
})

vim.lsp.enable('nixd')
vim.lsp.enable('qmlls')
vim.lsp.enable('htmx-lsp')

-- vim.lsp.config('qmlls', {
-- -- if qml doesn't work change this to where 'pacman -Ql qt6-declarative | grep qmlls' points
-- cmd = {'qmlls'}
-- })

vim.diagnostic.config({ virtual_text = true })

local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1

local servers = {
	"lua_ls",
	"bashls",
	"clangd",
	"gopls",
	"html",
	"cssls",
	"ts_ls",
	"marksman",
	"rust_analyzer",
	"emmet_ls",
	"jsonls",
	"yamlls",
	"taplo",
	"pyright",
}

-- pluguin for handling the lsp
--
return {
	{
		'mason-org/mason-lspconfig.nvim',
		enabled = not is_nixos,
		opts = {
			-- use the vim.lsp.config names! source: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
			ensure_installed = servers,
		},
		dependencies = {
			'mason-org/mason.nvim',
			'neovim/nvim-lspconfig',
		},
	},
	{
		'mason-org/mason.nvim',
		enabled = not is_nixos,
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		}
	},
	{
		'neovim/nvim-lspconfig',
		config = function()

			if is_nixos then
				for _, server in ipairs(servers) do
					vim.lsp.enable(server)
				end
			end
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })

					end

					map('grr', vim.lsp.buf.rename, '[R]ename')
					map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction')
					map('grh', vim.lsp.buf.hover, '[H]over Documentation')
					map('grd', vim.lsp.buf.type_definition, '[G]oto [D]efinition')
					map('grn', function() vim.diagnostic.jump({ count = 1 }) end, '[G]oto [N]ext Diagnostic')
					map('grp', function() vim.diagnostic.jump({ count = -1 }) end, '[G]oto [P]revious Diagnostic')

				end
			})
		end

	},
}

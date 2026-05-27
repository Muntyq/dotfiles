-- autocomplete and snippets functionality
-- at the bottom there are the snippet libraries, add more if needed
-- 
--

return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")
			cmp.setup {
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				sources = {
					{ name = 'nvim_lsp'},
					{ name = 'luasnip' },
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end
				},
				mapping = {
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = false,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},

			}
		end
	},

	{
		-- bridges dmp and the neovim built in lsp
		'hrsh7th/cmp-nvim-lsp',
	},
	{
		-- bridges cmp and luasnip
		'saadparwaiz1/cmp_luasnip',
		dependencies = {
			'L3MON4D3/LuaSnip',
		},
	},
	{
		-- snippet engine uses the providers below to show snippets
		'L3MON4D3/LuaSnip',
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			'rafamadriz/friendly-snippets',
			--'patrickelectric/qml-snippets'
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end
	},
	{
		--general snippet provider
		'rafamadriz/friendly-snippets',
	},
	-- {
	-- 	--qml snippet provider
	-- 	'patrickelectric/qml-snippets'
	-- },
}

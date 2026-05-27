return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			--vim.cmd.colorscheme("tokyonight-night") --tokyonight-night-storm-day-moon
		end
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("kanagawa-wave") --kanagawa-dragon-wave-lotus
		end
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("gruvbox")
		end
	},
	{
		"xero/miasma.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("miasma")
		end
	},
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("nord")
		end,
	},
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.everforest_enable_italic = true
			vim.g.everforest_background = 'hard'
			-- vim.cmd.colorscheme("everforest")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("nightfox")
		end,
	},
	{
		"yonatanperel/lake-dweller.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("lake-dweller").setup({
				variant = "lake-dweller", --lake/ocean/pond-dweller
			})
			-- vim.cmd.colorscheme("lake-dweller")
		end,
	},
}

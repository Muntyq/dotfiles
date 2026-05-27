-- adds color background to color
--

return {
	{
		'catgoose/nvim-colorizer.lua',
		event = "BufReadPre",
		config = function ()
			require("colorizer").setup({
				filetypes = {
					"*",
				}
			})
		end,
	}
}

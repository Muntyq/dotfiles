--Parser generator
--
return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- add nex languages here
			local langs = {
				'go',
				'gomod',
				'gosum',
				'lua',
				'nix',
				'html',
				'bash',
				'rust',
				'c',
				'javascript',
				'typescript',
				'css',
				'json',
				'yaml',
				'toml',
				'markdown',
			}

			local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1

			if not is_nixos then
				require('nvim-treesitter').install(langs)
			end

			vim.api.nvim_create_autocmd('FileType', {
				callback = function(args)
					local buf, filetype = args.buf, args.match

					local language = vim.treesitter.language.get_lang(filetype)
					if not language then return end

					--Check if parser exists and load it
					if not vim.treesitter.language.add(language) then return end

					--Enable syntax highlighting and other features
					vim.treesitter.start(buf, language)

					--Folds
					--vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					--vim.wo[0][0].foldmethod = 'expr'

					--Indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	}
}

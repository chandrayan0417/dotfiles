return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.config")
			configs.setup({
				modules = {}, -- Add this
				ignore_install = {}, -- Add this
				sync_install = false,
				-- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"scss",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"c",
					"dockerfile",
					"gitignore",
					"http",
				},
				-- auto install above language parsers
				auto_install = false,
			})
		end,
	},
}

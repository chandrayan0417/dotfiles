return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				css = { "biome" },
				html = { "biome" },
				go = { "goimports", "gofumpt", "golines" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
			},
			formatters = {
				biome = {
					command = "biome",
					args = {
						"check",
						"--write",
						"--stdin-file-path",
						"$FILENAME",
					},
					stdin = true,
				},
			},
		},
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}

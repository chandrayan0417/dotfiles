return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_format = "fallback",
			-- },
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescript = { "biome-check" },
				typescriptreact = { "biome-check" },
				json = { "biome-check" },
				css = { "biome-check" },
				html = { "biome-check" },
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
		-- config = function(_, opts)
		-- 	require("conform").setup(opts)
		-- end,
	},

	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}

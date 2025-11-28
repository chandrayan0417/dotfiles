return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.icons",
		},
		config = function()
			require("render-markdown").setup({
				latex = { enabled = false },
				render_modes = { "n", "c", "t" },
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(ev)
					vim.treesitter.start(ev.buf, "markdown")
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = ":call mkdp#util#install()",
		keys = {
			{
				"<leader>M",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
	},
}

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-jest",
			"thenbe/neotest-playwright",
		},
		keys = {
			{ "<leader>t", name = "Test", desc = "Test" },
			{ "<leader>tr", "<cmd>Neotest run<cr>", desc = "Test Run" },
			{ "<leader>ti", "<cmd>Neotest output<cr>", desc = "Test Output" },
			{ "<leader>to", "<cmd>Neotest output-panel<cr>", desc = "Test Output Panel" },
			{ "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Test Summary" },
			{ "<leader>ta", "<cmd>lua require('neotest').run.run({ suite = true })<cr>", desc = "Test All (suite)" },
		},
		config = function()
			require("neotest").setup({
				consumers = {
					playwright = require("neotest-playwright.consumers").consumers,
				},
				settings = {
					watch = true,
				},
				adapters = {
					require("neotest-vitest"),
					require("neotest-jest"),
					require("neotest-playwright").adapter({
						options = {
							persist_project_selection = true,
							enable_dynamic_test_discovery = true,
						},
					}),
				},
			})
		end,
	},
	{
		"thenbe/neotest-playwright",
		keys = {
			{
				"<leader>tp",
				function()
					require("neotest-playwright").attachment()
				end,
				desc = "Launch test attachment",
			},
		},
	},
}

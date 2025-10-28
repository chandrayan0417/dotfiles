return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		-- event = "InsertEnter",
		opts = {
			suggestion = { enabled = true },
			panel = { enabled = true },
			filetypes = {
				["*"] = true,
			},
		},
		keys = {
			{ "<leader>C", "", desc = "Copilot" },
			{ "<leader>Ce", "<cmd>Copilot enable<cr>", desc = "Enable" },
			{ "<leader>Cd", "<cmd>Copilot disable<cr>", desc = "Disable" },
			{ "<leader>Ct", "<cmd>Copilot toggle<cr>", desc = "Toggle" },
			{ "<leader>Cs", "<cmd>Copilot status<cr>", desc = "Status" },
			{ "<leader>Cp", "<cmd>Copilot panel<cr>", desc = "Panel" },
		},
	},
}

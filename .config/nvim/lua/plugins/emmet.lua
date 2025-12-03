return {
	"olrtg/nvim-emmet",
	config = function()
		vim.keymap.set(
			{ "n", "v" },
			"<leader>P",
			require("nvim-emmet").wrap_with_abbreviation,
			{ desc = "Emmet abbreviation" }
		)
	end,
}

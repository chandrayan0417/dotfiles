return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	keys = {
		{
			"<space>m",
			function()
				require("treesj").toggle()
			end,
			desc = "Toggle TreeSJ Split/Join",
		},
	},
	config = function()
		require("treesj").setup()
	end,
}

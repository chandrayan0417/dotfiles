local function enable_transparency()
	local hl = vim.api.nvim_set_hl
	hl(0, "Normal", { bg = "none" })
	hl(0, "NormalFloat", { bg = "none" })
	hl(0, "LineNr", { bg = "none" })
	hl(0, "SignColumn", { bg = "none" })
	hl(0, "VertSplit", { bg = "none" })
	hl(0, "StatusLine", { bg = "none" })
	hl(0, "NonText", { bg = "none" })
	hl(0, "Directory", { bg = "none" })
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		require("catppuccin").setup({
			float = {
				transparent = true, -- enable transparent floating windows
				solid = false, -- use solid styling for floating windows, see |winborder|
			},
			flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
			transparent_background = true,
			auto_integrations = true,
		})
		vim.cmd.colorscheme("catppuccin")
		enable_transparency()
		vim.api.nvim_set_hl(0, "Directory", { bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	end,
}

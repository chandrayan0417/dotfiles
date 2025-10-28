return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true, -- 👈 ENABLE TreeSitter checks (important for JSX/TSX)
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
				typescript = { "template_string" },
				typescriptreact = { "template_string", "jsx_tag", "jsx_element" },
			},
		})
		-- Integrate with nvim-cmp (if used)
		local cmp_ok, cmp = pcall(require, "cmp")
		if cmp_ok then
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	end,
}

require("config.options")
require("config.lazy")

vim.api.nvim_create_autocmd("SwapExists", {
	callback = function(ev)
		vim.v.swapchoice = "e" -- 'e' for edit anyway
	end,
})
vim.keymap.set("n", "<leader>R", function()
	local old_name = vim.fn.expand("%")
	local new_name = vim.fn.input("Rename to: ", old_name)
	if new_name ~= "" and new_name ~= old_name then
		vim.cmd("saveas " .. new_name)
		vim.fn.delete(old_name)
		vim.cmd("bdelete " .. old_name)
		print("Renamed to " .. new_name)
	end
end, { desc = "Rename current file" })

-- Autocommand for printing the autosaved message
local group = vim.api.nvim_create_augroup("autosave", {})
vim.api.nvim_create_autocmd("User", {
	pattern = "AutoSaveWritePost",
	group = group,
	callback = function(opts)
		if opts.data.saved_buffer ~= nil then
			print("AutoSaved")
		end
	end,
})

-- Visual mode events to prevent saving while moving/deleting text
local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
	group = visual_event_group,
	pattern = { "*:[vV\x16]*" },
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "VisualEnter" })
	end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	group = visual_event_group,
	pattern = { "[vV\x16]*:*" },
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "VisualLeave" })
	end,
})

-- Override flash.jump to emit user events
local flash = require("flash")
local original_jump = flash.jump

flash.jump = function(opts)
	vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpStart" })
	original_jump(opts)
	vim.api.nvim_exec_autocmds("User", { pattern = "FlashJumpEnd" })
end

-- Disable auto-save in snacks_input buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "snacks_input",
	group = group,
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputEnter" })
	end,
})

-- Disable auto-save in snacks_picker_input buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = "snacks_picker_input",
	group = group,
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputEnter" })
	end,
})

-- Re-enable auto-save on BufLeave for both snacks_input types
vim.api.nvim_create_autocmd("BufLeave", {
	group = group,
	pattern = "*",
	callback = function(opts)
		local ft = vim.bo[opts.buf].filetype
		if ft == "snacks_input" then
			vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputLeave" })
		elseif ft == "snacks_picker_input" then
			vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputLeave" })
		end
	end,
})

-- Plugin configuration
return {
	{
		"okuuva/auto-save.nvim",
		enabled = true,
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = {
			enabled = true,
			trigger_events = {
				immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
				defer_save = {
					"InsertLeave",
					"TextChanged",
					{ "User", pattern = "VisualLeave" },
					{ "User", pattern = "FlashJumpEnd" },
					{ "User", pattern = "SnacksInputLeave" },
					{ "User", pattern = "SnacksPickerInputLeave" },
				},
				cancel_deferred_save = {
					"InsertEnter",
					{ "User", pattern = "VisualEnter" },
					{ "User", pattern = "FlashJumpStart" },
					{ "User", pattern = "SnacksInputEnter" },
					{ "User", pattern = "SnacksPickerInputEnter" },
				},
			},
			condition = function(buf)
				local mode = vim.fn.mode()
				if mode == "i" then
					return false
				end

				local filetype = vim.bo[buf].filetype
				if filetype == "harpoon" or filetype == "mysql" then
					return false
				end

				local ok, luasnip = pcall(require, "luasnip")
				if ok then
					local success, in_snippet = pcall(luasnip.in_snippet)
					if success and in_snippet then
						return false
					end
				end

				return true
			end,
			write_all_buffers = false,
			noautocmd = false,
			lockmarks = false,
			debounce_delay = 3000,
			debug = false,
		},
	},
}

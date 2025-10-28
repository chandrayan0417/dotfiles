return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options = {
			icons_enabled = true,
			theme = "catppuccin",
			globalstatus = true, -- Must be true for single line
			component_separators = "",
			section_separators = "",
		}

		opts.sections = {
			lualine_a = { "mode" },
			lualine_c = {
				{
					"filename",
					path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
				"diagnostics",
			},
			lualine_b = {
				{
					"branch",
					-- icon = "🌿", -- Git branch icon
				},
				{
					"diff",
					symbols = {
						added = "+ ", -- Added lines
						modified = "~ ", -- Modified lines
						removed = "- ", -- Deleted lines
					},
					colored = true,
				},
			},
			lualine_x = { "location" }, -- cursor position
			lualine_y = { "filetype" },
			lualine_z = {
				"progress",
			},
		}

		opts.inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "filetype" },
			lualine_y = {},
			lualine_z = {},
		}
		opts.laststatus = 0 --vim tpipeline
	end,
}

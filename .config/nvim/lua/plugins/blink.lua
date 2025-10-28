return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip").filetype_extend("typescriptreact", { "html" })
				end,
			},
			"fang2hou/blink-copilot", -- Add the Copilot provider as a dependency
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = { preset = "luasnip" },

			keymap = {
				preset = "default",

				-- TAB to navigate next item, expand snippets, or fallback
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

				-- SHIFT+TAB to navigate previous item or fallback
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

				-- ENTER to accept selected item or create newline
				["<CR>"] = { "accept", "hide", "fallback" },

				-- CTRL+Space to show completion menu
				["<C-Space>"] = { "show" },

				-- Optional: CTRL+E to hide manually
				["<C-e>"] = { "hide" },

				-- -- Optional: Navigation with CTRL+N / CTRL+P
				-- ["<C-n>"] = { "select_next", "fallback" },
				-- ["<C-p>"] = { "select_prev", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			signature = {
				enabled = true,
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				menu = {
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
			},

			sources = {
				default = {
					"copilot", -- Copilot is now a completion source!
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},

		opts_extend = { "sources.default" },
	},
}

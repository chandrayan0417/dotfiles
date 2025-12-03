return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local mason = require("mason")
			local mason_lsp = require("mason-lspconfig")
			local mason_tools = require("mason-tool-installer")

			-- Setup Mason
			mason.setup()

			-- Setup Mason LSPConfig with servers to ensure installed
			mason_lsp.setup({
				ensure_installed = {
					"ts_ls",
					"cssls",
					"jsonls",
					"tailwindcss",
					"biome",
					-- "lua_ls",
					"emmet_language_server",
					"html",
					"gopls",
					"bashls",
					"dockerls",
					"gh_actions_ls",
					"yamlls",
				},
			})

			-- Setup Mason Tool Installer for formatters/linters/lsp servers
			mason_tools.setup({
				ensure_installed = {
					"stylua",
					"tailwindcss-language-server",
					"typescript-language-server",
					-- "lua-language-server",
					"gofumpt",
					"goimports",
					"golines",
					"golangci-lint",
				},
				auto_update = false,
				run_on_start = true,
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				ts_ls = { capabilities = capabilities },
				cssls = { capabilities = capabilities },
				gopls = { capabilities = capabilities },
				jsonls = { capabilities = capabilities },
				yamlls = { capabilities = capabilities },
				dockerls = { capabilities = capabilities },
				bashls = { capabilities = capabilities },
				emmet_language_server = { capabilities = capabilities },
				gh_actions_ls = { capabilities = capabilities },
				tailwindcss = {
					capabilities = capabilities,
					settings = {
						tailwindCSS = { classFunctions = { "cva", "cx" } },
					},
				},
				biome = {
					capabilities = capabilities,
					cmd = { "biome", "lsp-proxy" },
					root_dir = lspconfig.util.root_pattern("biome.json", ".git"),
					single_file_support = false,
				},
				lua_ls = { capabilities = capabilities, cmd = { "lua-language-server" } },
				html = { capabilities = capabilities },
			}

			-- Setup installed LSP servers with defaults, merging overrides
			mason_lsp.setup({
				handlers = {
					function(server)
						local opts = { capabilities = capabilities }
						if servers[server] then
							opts = vim.tbl_deep_extend("force", opts, servers[server])
						end
						require("lspconfig")[server].setup(opts)
					end,
				},
			})

			-- Workspace diagnostics integration from second config
			if vim.lsp and vim.lsp.config then
				vim.lsp.config("*", {
					on_attach = function(client, bufnr)
						if package.loaded["workspace-diagnostics"] then
							require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
						end
					end,
				})
			end
		end,
	},
}

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
					"lua_ls",
					"emmet_ls",
					"html",
				},
			})

			-- Setup Mason Tool Installer for formatters/linters/lsp servers
			mason_tools.setup({
				ensure_installed = {
					"stylua",
					"tailwindcss-language-server",
					"ts_ls",
					"lua-language-server",
				},
				auto_update = false,
				run_on_start = true,
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				ts_ls = {
					capabilities = capabilities,
					-- on_attach = function(client, _)
					-- 	-- Disable diagnostics for this LSP (as in your snippet)
					-- 	client.handlers["textDocument/publishDiagnostics"] = function() end
					-- end,
				},
				cssls = { capabilities = capabilities },
				jsonls = { capabilities = capabilities },
				tailwindcss = {
					capabilities = capabilities,
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
					settings = {
						tailwindCSS = {
							classFunctions = { "cva", "cx" },
						},
					},
				},
				biome = {
					capabilities = capabilities,
					cmd = { "biome", "lsp-proxy" },
					filetypes = {
						"css",
						"graphql",
						"html",
						"javascript",
						"javascriptreact",
						"json",
						"jsonc",
						"typescript",
						"typescript.tsx",
						"typescriptreact",
					},
					root_dir = lspconfig.util.root_pattern("biome.json", ".git"),
					single_file_support = false,
				},
				lua_ls = { capabilities = capabilities },
				html = { capabilities = capabilities },
			}

			-- Setup each LSP server
			for name, opts in pairs(servers) do
				lspconfig[name].setup(opts)
			end

			-- Workspace diagnostics integration from second config
			vim.lsp.config("*", {
				on_attach = function(client, bufnr)
					if package.loaded["workspace-diagnostics"] then
						require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					end
				end,
			})

			-- -- LSP keymaps on attach (see first config)
			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	callback = function(args)
			-- 		local bufnr = args.buf
			-- 		local map = vim.keymap.set
			-- 		local opts = { buffer = bufnr }
			--
			-- 		map("n", "gd", vim.lsp.buf.definition, opts)
			-- 		map("n", "K", vim.lsp.buf.hover, opts)
			-- 		map("n", "gi", vim.lsp.buf.implementation, opts)
			-- 		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
			-- 		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			-- 		map("n", "<leader>f", function()
			-- 			vim.lsp.buf.format({ async = true })
			-- 		end, opts)
			-- 	end,
			-- })
		end,
	},
}

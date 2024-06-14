return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup()

		local HTML_LIKE = { "astro", "html", "svelte", "templ", "vue" }

		local on_attach = function(_, bufnr)
			local bmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. "[" .. keys .. "] " .. desc
				end
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			bmap("<leader>r", vim.lsp.buf.rename, "Rename")
			bmap("<leader>a", vim.lsp.buf.code_action, "Code action")

			bmap("gd", vim.lsp.buf.definition, "Goto Definition")
			bmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
			bmap("gI", vim.lsp.buf.implementation, "Goto Implementation")
			bmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")

			-- bmap('K', vim.lsp.buf.hover, 'Hover docs');
			bmap("<C-k>", vim.lsp.buf.signature_help, "Signature docs")

			-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
			-- vim.lsp.buf.format()
			-- end, {});

			-- local format_is_enabled = true;
			-- vim.api.nvim_buf_create_user_command('AutoFormatToggle', function()
			-- format_is_enabled = not format_is_enabled;
			-- print('Setting autoformatting to:' .. tostring(format_is_enabled));
			-- end, {});
		end

		local set_handler = function(server_name, config)
			return function()
				require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, config))
			end
		end

		if not table.unpack then
			table.unpack = unpack
		end

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"tsserver",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = set_handler("lua_ls", {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				}),
				["emmet_ls"] = set_handler("emmet_ls", {
					filetypes = { table.unpack(HTML_LIKE) },
				}),
				["gopls"] = set_handler("gopls", {
					filetypes = { "templ", "go", "gomod", "gowork", "gotmpl" },
				}),
				["html"] = set_handler("html", {
					filetypes = { table.unpack(HTML_LIKE) },
				}),
				["htmx"] = set_handler("htmx", {
					filetypes = { table.unpack(HTML_LIKE) },
				}),
				["unocss"] = set_handler("unocss", {
					filetypes = { table.unpack(HTML_LIKE) },
				}),
				["templ"] = function()
					vim.filetype.add({ extension = { templ = "templ" } })
					return set_handler("templ", {
						filetypes = { table.unpack(HTML_LIKE) },
					})
				end,
			},
		})
	end,
}

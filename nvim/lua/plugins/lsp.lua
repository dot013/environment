return {
	{
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
			"lewis6991/hover.nvim",
			"folke/which-key.nvim",
			"folke/lazydev.nvim",
			"rafamadriz/friendly-snippets",
			"nvim-tree/nvim-web-devicons",
			"onsails/lspkind.nvim",
			"folke/trouble.nvim",
			"mhartington/formatter.nvim",
		},
		lazy = false,
		config = function()
			require("which-key").register({
				["<leader>c"] = { name = "[c] Code", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[d] Document", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[g] Git", _ = "which_key_ignore" },
				["<leader>h"] = { name = "[h] More Git", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[r] Rename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[s] Search", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[w] Workspace", _ = "which_key_ignore" },
			})

			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
				end,
				preview_opts = {
					border = "single",
				},
				preview_window = false,
				title = true,
				mouse_providers = { "LSP" },
				mouse_delay = 1000,
			})
			vim.keymap.set("n", "K", function()
				local win = vim.b.hover_preview
				if win and vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_set_current_win(win)
				else
					require("hover").hover()
				end
			end, { desc = "[K] Hover" })

			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			require("fidget").setup()

			local HTML_LIKE = { "astro", "html", "svelte", "templ", "vue" }
			vim.filetype.add({ extension = { templ = "templ" } })

			local set_handler = function(server_name, config)
				return function()
					require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
						capabilities = capabilities,
					}, config))
				end
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
					["gopls"] = set_handler("gopls", {
						filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
					["templ"] = set_handler("templ", {
						cmd = { "templ", "lsp" },
						root_dir = require("lspconfig.util").root_pattern("go.mod", ".git"),
						settings = {},
						filetypes = { "templ" },
					}),
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{ "<leader>t", "<cmd>Trouble diagnostics toggle<cr>", desc = "[<leader>t] Trouble: Diagnostics" },
			{
				"<leader>T",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "[<leader>t] Trouble: Buffer Diagnostics",
			},
			{
				"<leader>s",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "[<leader>s] Trouble: Rename Symbols",
			},
			{
				"<leader>l",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "[<leader>t] Trouble: LSP Definitions / references",
			},
		},
	},
}

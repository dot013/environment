return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind.nvim",
		},
		config = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			vim.o.pumheight = 20

			local cmp = require("cmp")
			local cmp_defaults = require("cmp.config.default")()

			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				enabled = true,
				competion = {
					autocomplete = cmp_defaults.completion.autocomplete,
					get_trigger_characters = cmp_defaults.completion.get_trigger_characters,
					keyword_length = cmp_defaults.completion.keyword_length,
					keyword_pattern = cmp_defaults.completion.keyword_pattern,
					completeopt = "menu,menuone,noinsert,noselect",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({
								behavior = cmp.SelectBehavior.Insert,
							})
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({
								behavior = cmp.SelectBehavior.Insert,
							})
						elseif luasnip.jumpable(-1) then
							luasnip.expand_or_jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
				}, {
					{ name = "buffer" },
				}),
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
						},
					}),
					fields = cmp_defaults.formatting.fields,
					expandable_indicator = cmp_defaults.formatting.expandable_indicator,
				},
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
					docs = cmp_defaults.view.docs,
				},
				sorting = cmp_defaults.sorting,
				performance = cmp_defaults.performance,
				preselect = cmp_defaults.preselect,
				confirmation = cmp_defaults.confirmation,
				matching = cmp_defaults.matching,
				revision = cmp_defaults.revision,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			extra = {
				above = "gc0",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
		},
	},
}

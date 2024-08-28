return {
	{
		"okuuva/auto-save.nvim",
		lazy = false,
		event = { "InsertLeave", "TextChanged" },
		opts = {
			condition = function(buf)
				if vim.bo[buf].filetype == "harpoon" then
					return false
				end
				return true
			end,
		},
	},
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-fugitive" },
	{ "tpope/vim-rhubarb" },
	{
		"tpope/vim-obsession",
		lazy = false,
	},
	{ "lambdalisue/suda.vim" },
	{
		"laytan/cloak.nvim",
	},
	{
		"folke/neodev.nvim",
		lazy = false,
		config = function()
			require("neodev").setup({
				library = {
					plugins = {
						"nvim-dap-ui",
					},
					type = true,
				},
			})
		end,
	},
}

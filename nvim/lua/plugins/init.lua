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
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = { { "<leader>gg", "<cmd>:LazyGit<cr>", desc = "[gg] Lazygit" } },
	},
	{ "lambdalisue/suda.vim" },
	{
		"laytan/cloak.nvim",
	},
}

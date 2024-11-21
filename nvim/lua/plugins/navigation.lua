return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local function map(mode, keys, func, desc, opts)
			if desc then
				desc = "[" .. keys .. "] " .. desc
			end
			if opts then
				vim.keymap.set(mode, keys, func, vim.tbl_extend("force", { desc = desc }, opts))
			else
				vim.keymap.set(mode, keys, func, { desc = desc })
			end
		end
		-- Harpoon ------------------------------

		local harpoon = require("harpoon")
		harpoon:setup()

		map("n", "<leader>w", function()
			harpoon:list():add()
		end, "[Harpoon] Append to list")
		map("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, "[Harpoon] Open quick menu")

		map("n", "1", function()
			harpoon:list():select(1)
		end, "[Harpoon] Jump to item 1")
		map("n", "2", function()
			harpoon:list():select(2)
		end, "[Harpoon] Jump to item 2")
		map("n", "3", function()
			harpoon:list():select(3)
		end, "[Harpoon] Jump to item 3")
		map("n", "4", function()
			harpoon:list():select(4)
		end, "[Harpoon] Jump to item 4")

		map("n", "<C-p>", function()
			harpoon:list():prev()
		end, "[Harpoon] Jump to previous item")
		map("n", "<C-n>", function()
			harpoon:list():next()
		end, "[Harpoon] Jump to next item")
	end,
}

local autocmd = function(event, opts)
	vim.api.nvim_create_autocmd(
		event,
		vim.tbl_extend("force", {
			group = vim.api.nvim_create_augroup("guz_group", {}),
		}, opts)
	)
end

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

local function cmap(cmd, func, opts)
	vim.api.nvim_create_user_command(cmd, func, opts)
end

-- Thank you ThePrimeagen ---------------

-- Move when highlighted
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Make cursor stay in place when using J
map("n", "J", "mzJ`z")

-- Make cursor stay in the middle when jumping
-- with ctrl+d and ctrl+u
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Just to be sure, whatever
map("n", "<C-c>", "<Esc>")

-- Don't press Q
map("n", "Q", "<nop>")

-- Delete to the void
map("n", "<leader>d", '"_d')
map("v", "<leader>d", '"_d')

-- Replace current word in entire file
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Turn file into a Linux executable
map("n", "<leader>mod", "<cmd>!chmod +x %<CR>", "Turn into executable", { silent = true })

-- --------------------------------------

map("n", "<leader>w\\", "<cmd>:vsplit<cr>", "Splits the window vertically")
map("n", "<leader>w/", "<cmd>:split<cr>", "Splits the window horizontally")

map("n", "<leader>e", "<cmd>:Ex<cr>", "Explorer")

map("n", "s=", "z=", "Suggest spelling correction")
map("n", "<leader>st", function()
	if vim.o.spell then
		vim.o.spell = false
	else
		vim.o.spell = true
	end
end, "Toggle spelling correction")

map("n", "<leader>ee", vim.diagnostic.open_float, "Open diagnostic")

map({ "n", "v" }, "<Space>", "<Nop>", "Nop", { silent = true })

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "", { expr = true, silent = true })

-- Barbar -------------------------------

map("n", "bc", "<cmd>BufferClose<cr>", "Buffer close", { noremap = true, silent = true })
map("n", "bA", "<cmd>BufferCloseAllButCurrent<cr>", "Buffer close all but current", { noremap = true, silent = true })

-- Lsp ----------------------------------

autocmd("LspAttach", {
	callback = function(e)
		local opts = { buffer = e.buf }
		map("n", "<leader>r", vim.lsp.buf.rename, "Rename", opts)
		map("n", "<leader>a", vim.lsp.buf.code_action, "Code action", opts)

		map("n", "gd", vim.lsp.buf.definition, "Goto Definition", opts)
		map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration", opts)
		map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation", opts)
		map("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition", opts)

		map("n", "K", require("hover").hover, "[K] Hover", opts)
		map("n", "sK", require("hover").hover_select, "[K] Hover select", opts)
	end,
})

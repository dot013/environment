return {
	{
		"mhartington/formatter.nvim",
		config = function()
			local formatter_util = require("formatter.util")
			vim.api.nvim_create_augroup("__formatter__", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					typescriptreact = {
						function()
							if vim.fn.executable("prettierd") == 1 then
								return require("formatter.filetypes.javascriptreact").prettierd()
							elseif vim.fn.executable("prettier") == 1 then
								return require("formatter.filetypes.javascriptreact").prettier()
							end
							return nil
						end,
					},
					go = {
						function()
							if vim.fn.executable("gofumpt") == 1 then
								return require("formatter.filetypes.go").gofumpt()
							end
							return require("formatter.filetypes.go").gofmt()
						end,
						function()
							if vim.fn.executable("golines") == 1 then
								return require("formatter.filetypes.go").golines()
							elseif vim.fn.executable("goimports") == 1 then
								return require("formatter.filetypes.go").goimports()
							end
							return nil
						end,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
						function()
							return {
								exe = "stylua",
								args = {
									"--search-parent-directories",
									"--stdin-filepath",
									formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
									"--",
									"-",
								},
								stdin = true,
							}
						end,
					},
					nix = {
						require("formatter.filetypes.nix").alejandra,
					},
					sh = {
						function()
							if vim.fn.executable("shfmt") == 1 then
								return require("formatter.filetypes.sh").shfmt()
							end
							return nil
						end,
						function()
							if vim.fn.executable("shellharden") == 1 then
								return {
									exe = "shellharden",
									args = { "--replace" },
								}
							end
							return nil
						end,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
}

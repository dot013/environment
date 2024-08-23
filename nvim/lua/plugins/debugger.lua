return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			--[[ {
				"Joakker/lua-json5",
			}, ]]
		},
		lazy = false,
		config = function()
			local dap = require("dap")
			local dapgo = require("dap-go")

			-- require("dap.ext.vscode").json_decode = require("json5").parse

			dapgo.setup()

			local nmap = function(key, func, desc)
				if desc then
					desc = "[" .. key .. "] " .. desc
				end
				vim.keymap.set("n", key, func, { desc = desc })
			end

			nmap("<leader>xj", require("dap.ext.vscode").load_launchjs)

			nmap("<leader>xb", dap.toggle_breakpoint)
			nmap("<leader>xB", dap.set_breakpoint)
			nmap("<leader>xc", dap.continue)
			nmap("<leader>xo", dap.step_over)
			nmap("<leader>xi", dap.step_into)
			nmap("<leader>xO", dap.repl.open)

			nmap("<leader>xh", require("dap.ui.widgets").hover)
			nmap("<leader>xp", require("dap.ui.widgets").preview)
		end,
	},
}

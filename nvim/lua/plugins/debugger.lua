return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			{
				"Joakker/lua-json5",
				build = "./install.sh",
			},
		},
		lazy = false,
		config = function()
			local dap = require("dap")
			local dapgo = require("dap-go")

			require("dap.ext.vscode").json_decode = require("json5").parse

			dap.setup()
			dapgo.setup()

			local nmap = function(key, func, desc)
				if desc then
					desc = "[" .. key .. "] " .. desc
				end
				vim.keymap.set("n", key, func, { desc = desc })
			end

			nmap("<leader>dj", require("dap.ext.vscode").load_launchjs())

			nmap("<leader>dp", dap.toggle_breakpoint())
			nmap("<leader>dc", dap.continue())
			nmap("<leader>do", dap.step_over())
			nmap("<leader>di", dap.step_into())
			nmap("<leader>dO", dap.repl.open())
		end,
	},
}

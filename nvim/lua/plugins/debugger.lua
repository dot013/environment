return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local nmap = function(key, func, desc)
				if desc then
					desc = "[" .. key .. "] Debugger: " .. desc
				end
				vim.keymap.set("n", key, func, { desc = desc })
			end

			local dap = require("dap")
			local dapgo = require("dap-go")
			local dapvt = require("nvim-dap-virtual-text")

			dapgo.setup()
			dapvt.setup()

			nmap("<leader>b", dap.toggle_breakpoint, "Toggle breakpoint")
			nmap("<leader>B", dap.set_breakpoint, "Set breakpoint")
			nmap("<leader>x", dap.continue, "Continue")
			nmap("<leader>rl", dap.run_last, "Run last")
			nmap("<leader>X", dap.terminate, "Terminate debugger")
			nmap("<leader>C", dap.clear_breakpoints, "Clear all breakpoints")

			local dapui = require("dapui")
			dapui.setup()

			nmap("<leader>bI", dapui.toggle, "Open debugger interface")
			nmap("<leader>K", function()
				dapui.eval(nil, { enter = true })
			end, "Eval var under cursor")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}

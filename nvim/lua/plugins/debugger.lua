return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		lazy = false,
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

			nmap("xj", require("dap.ext.vscode").load_launchjs, "Load .vscode/launch.json")

			nmap("xb", dap.toggle_breakpoint, "Toggle breakpoint")
			nmap("xB", dap.set_breakpoint, "Set breakpoint")
			nmap("xc", dap.continue, "Continue")
			nmap("xl", dap.run_last, "Run last")
			nmap("xo", dap.step_over, "Step Over")
			nmap("xi", dap.step_into, "Step Into")
			nmap("xO", dap.repl.open, "Open Repl")
			nmap("xX", dap.terminate, "Terminate debugger")
			nmap("xC", dap.clear_breakpoints, "Clear all breakpoints")

			nmap("xp", require("dap.ui.widgets").preview, "Preview")

			local dapui = require("dapui")
			dapui.setup()

			nmap("xU", dapui.toggle, "Open debugger interface")
			nmap("xK", function()
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

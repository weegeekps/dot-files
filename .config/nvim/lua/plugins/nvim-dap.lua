return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio", -- Required for nvim-dap-ui
    },
    opts = {
        layouts = {},
        controls = {
            enabled = true,
            element = "repl",
        },
    },
    keys = {
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Continue / Start",
        },
        {
            "<F10>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F11>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<S-F11>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
        },
        {
            "<Leader>db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Debug: Toggle Breakpoint",
        },
        {
            "<Leader>dB",
            function()
                require("dap").set_breakpoint(vim.fn.input("Condition: "))
            end,
            desc = "Debug: Conditional Breakpoint",
        },
        {
            "<Leader>du",
            function()
                require("dapui").toggle()
            end,
            desc = "Debug: Toggle UI",
        },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("nvim-dap-virtual-text").setup()
        dapui.setup({
            controls = {
                enabled = true,
                element = "repl",
            },
        })

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "--interpreter=dap", "--eval-command", "set pretty print on" },
        }

        -- Automatically trigger dap-ui opening/closing; edgy.nvim will intercept the layout
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
}

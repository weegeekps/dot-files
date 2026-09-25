return {
    "Civitasv/cmake-tools.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    ft = { "c", "cpp", "cmake" },
    cmd = {
        "CMakeGenerate",
        "CMakeBuild",
        "CMakeRun",
        "CMakeDebug",
        "CMakeRunTest",
        "CMakeSelectBuildTarget",
        "CMakeSelectLaunchTarget",
        "CMakeSelectBuildType",
        "CMakeSelectConfigurePreset",
        "CMakeSelectBuildPreset",
        "CMakeSettings",
        "CMakeClean",
    },
    keys = {
        { "<Leader>mg", "<cmd>CMakeGenerate<CR>", desc = "CMake Generate" },
        { "<Leader>mb", "<cmd>CMakeBuild<CR>", desc = "CMake Build" },
        { "<Leader>mr", "<cmd>CMakeRun<CR>", desc = "CMake Run" },
        { "<Leader>md", "<cmd>CMakeDebug<CR>", desc = "CMake Debug" },
        { "<Leader>mt", "<cmd>CMakeRunTest<CR>", desc = "CMake Run Tests" },
        { "<Leader>mc", "<cmd>CMakeClean<CR>", desc = "CMake Clean" },
        { "<Leader>msb", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake Select Build Target" },
        { "<Leader>msl", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake Select Launch Target" },
        { "<Leader>msp", "<cmd>CMakeSelectConfigurePreset<CR>", desc = "CMake Select Configure Preset" },
        { "<Leader>msP", "<cmd>CMakeSelectBuildPreset<CR>", desc = "CMake Select Build Preset" },
        { "<Leader>mst", "<cmd>CMakeSelectBuildType<CR>", desc = "CMake Select Build Type" },
        { "<Leader>m?", "<cmd>CMakeSettings<CR>", desc = "CMake Settings" },
    },
    config = function()
        require("cmake-tools").setup({
            cmake_use_preset = true,
            cmake_regenerate_on_save = true,
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },

            -- Keeps compile_commands.json symlinked at the project root so clangd
            -- picks it up without the --compile-commands-dir flag.
            cmake_compile_commands_options = {
                action = "soft_link",
                target = vim.uv.cwd,
            },

            -- Must match the dap.adapters key in nvim-dap.lua. The plugin default
            -- is codelldb, which you don't have registered.
            cmake_dap_configuration = {
                name = "cpp",
                type = "gdb",
                request = "launch",
                stopAtBeginningOfMainSubprogram = false,
            },

            -- Build output into the quickfix list, so <Leader>dQ (Trouble qflist)
            -- shows compiler errors.
            cmake_executor = {
                name = "quickfix",
                opts = {
                    show = "only_on_error",
                    position = "belowright",
                    size = 10,
                    auto_close_when_success = true,
                },
            },

            cmake_runner = {
                name = "terminal",
                opts = {
                    prefix_name = "[CMakeTools]: ",
                    split_direction = "horizontal",
                    split_size = 11,
                    focus = false,
                },
            },
        })
    end,
}

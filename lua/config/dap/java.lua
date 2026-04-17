local dap = require("dap")

dap.configurations.java = {
    {
        name = "Launch file",
        type = "java",
        request = "launch",
        mainClass = function()
            return vim.fn.input("Main class (ex: com.example.Main): ")
        end,
    },
    {
        name = "Launch file (current)",
        type = "java",
        request = "launch",
        mainClass = "${file}",
    },
    {
        name = "Attach to process (5005)",
        type = "java",
        request = "attach",
        hostName = "localhost",
        port = 5005,
    },
    {
        name = "Attach to process (custom port)",
        type = "java",
        request = "attach",
        hostName = "localhost",
        port = function()
            return tonumber(vim.fn.input("Port: ")) or 5005
        end,
    },
}

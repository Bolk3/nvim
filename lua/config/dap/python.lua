local dap = require("dap")

dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    -- Script simple
    {
        name = "Launch file",
        type = "python",
        request = "launch",
        program = "${file}",
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
        end,
    },
    -- Script avec arguments
    {
        name = "Launch file with args",
        type = "python",
        request = "launch",
        program = "${file}",
        args = function()
            local args = vim.fn.input("Arguments: ")
            return vim.split(args, " ")
        end,
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or vim.fn.exepath("python3") or "python"
        end,
    },
    -- Flask
    {
        name = "Flask",
        type = "python",
        request = "launch",
        module = "flask",
        args = { "run", "--no-debugger", "--no-reload" },
        env = {
            FLASK_APP = function()
                return vim.fn.input("FLASK_APP: ", "app.py")
            end,
            FLASK_ENV = "development",
        },
        jinja = true,
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or "python"
        end,
    },
    -- Django
    {
        name = "Django",
        type = "python",
        request = "launch",
        program = function()
            return vim.fn.input("manage.py: ", vim.fn.getcwd() .. "/manage.py", "file")
        end,
        args = { "runserver", "--noreload" },
        django = true,
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or "python"
        end,
    },
    -- FastAPI
    {
        name = "FastAPI",
        type = "python",
        request = "launch",
        module = "uvicorn",
        args = function()
            local app = vim.fn.input("App (ex: main:app): ", "main:app")
            return { app, "--reload" }
        end,
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or "python"
        end,
    },
    -- Pytest
    {
        name = "Pytest (file)",
        type = "python",
        request = "launch",
        module = "pytest",
        args = { "${file}", "-v" },
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or "python"
        end,
    },
    -- Pytest avec filtre
    {
        name = "Pytest (filter)",
        type = "python",
        request = "launch",
        module = "pytest",
        args = function()
            local filter = vim.fn.input("Test filter (-k): ")
            return { "-v", "-k", filter }
        end,
        pythonPath = function()
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
                return venv
            end
            return vim.fn.exepath("python") or "python"
        end,
    },
}

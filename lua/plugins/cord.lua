return {
    'vyfor/cord.nvim',
    opts = function ()
        return {
            display = {
                theme = "minecraft",
                flavor = "dark",
            },
            idle = {
                details = function(opts)
                    return string.format('Taking a break from %s', opts.workspace)
                end
            },
        }
    end
}

local nightfox = require('nightfox')

nightfox.setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
        }
    }
})

vim.cmd("colorscheme nordfox")

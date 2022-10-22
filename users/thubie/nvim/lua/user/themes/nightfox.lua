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

nightfox.load('nordfox')

vim.cmd("colorscheme nightfox")

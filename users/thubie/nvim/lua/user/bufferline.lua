require("bufferline").setup {
    options = {
        mode = "buffers",
        offset = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                seperator = true -- use a "true" to enable the default, or set your own character
            }
        },
    }
}

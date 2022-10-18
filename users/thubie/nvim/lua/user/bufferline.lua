local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

bufferline.setup {
    options = {
        offset = {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            seperator = true -- use a "true" to enable the default, or set your own character
        }
    }
}

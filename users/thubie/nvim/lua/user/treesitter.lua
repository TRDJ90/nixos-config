-- nvim-treesitter
require"nvim-treesitter.configs".setup {
    ensure_install = "maintained",
    sync_install = false,
    ignore_install = { "" },
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highligting = false,
    },
    indent = {
        enable = true,
        disable = { "yaml" },
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    autopairs = {
        enable = true,
    },
}

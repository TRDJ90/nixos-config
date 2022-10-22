local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then return end

local navic_ok, navic = pcall(require, "nvim-navic")
if not navic_ok then return end

-- TODO: create a ui.lua?
navic.setup {
    icons = {
        File          = " ",
        Module        = " ",
        Namespace     = " ",
        Package       = " ",
        Class         = " ",
        Method        = " ",
        Property      = " ",
        Field         = " ",
        Constructor   = " ",
        Enum          = "練",
        Interface     = "練",
        Function      = " ",
        Variable      = " ",
        Constant      = " ",
        String        = " ",
        Number        = " ",
        Boolean       = "◩ ",
        Array         = " ",
        Object        = " ",
        Key           = " ",
        Null          = "ﳠ ",
        EnumMember    = " ",
        Struct        = " ",
        Event         = " ",
        Operator      = " ",
        TypeParameter = " ",
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
}

-- TODO: place to colors.lua?
vim.api.nvim_set_hl(0, "NavicIconsFile",          {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsModule",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsNamespace",     {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsPackage",       {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsClass",         {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsMethod",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsProperty",      {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsField",         {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsConstructor",   {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsEnum",          {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsInterface",     {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsFunction",      {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsVariable",      {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsConstant",      {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsString",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsNumber",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsBoolean",       {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsArray",         {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsObject",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsKey",           {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsNull",          {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsEnumMember",    {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsStruct",        {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsEvent",         {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsOperator",      {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicText",               {default = true, bg = "#000000", fg = "#ffffff"})
vim.api.nvim_set_hl(0, "NavicSeparator",          {default = true, bg = "#000000", fg = "#ffffff"})

lualine.setup {
    options = {
        icons_enabled = true,
        theme = "nordfox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        { "filename" },
        {
          navic.get_location,
          cond = navic.is_available,
          color = { fg = "#f3ca28" },
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
}

local floats = {
    "Float",
    "NormalFloat",
    "TelescopePromptNormal",
    "TelescopeResultsNormal",
    "TelescopePreviewNormal",
    "HarpoonWindow",
}

local float_borders = {
    "NormalFloatBorder",
    "FloatBorder",
    "TelescopeBorder",
    "HarpoonBorder",
}

-- doom-one
--local custom_bg = "#282c34"
--local custom_border = "#51AFEF"

-- rose pine
--local custom_bg = "#1f1d2e"
--local custom_border = "#9ccfd8"

-- cyberdream
local custom_bg = "#16181a"
local custom_border = "#f1ff5e"
--local custom_border = "#5ea1ff"
--local custom_border = "#bd5eff"

function SetColors(color)
    color = color or "doom-one"

    vim.cmd.colorscheme(color)

    -- make bg transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = custom_bg, fg = custom_border })
    vim.api.nvim_set_hl(0, "LineNrAbove", { bg = "none", fg = "gray" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = custom_bg, fg = "none" })
    vim.api.nvim_set_hl(0, "LineNrBelow", { bg = "none", fg = "gray" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = custom_border })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", fg = custom_border })

    -- color floats
    for _, value in pairs(floats) do
        vim.api.nvim_set_hl(0, value, { bg = "none" })
    end
    for _, value in pairs(float_borders) do
        vim.api.nvim_set_hl(0, value, { fg = custom_border, bg = "none" })
    end
end

SetColors("cyberdream")

local mode_icons = {
	NORMAL = "󰰓",
	INSERT = "󰰄",
	VISUAL = "󰈈",
	["V-LINE"] = "󰈈",
	["V-BLOCK"] = "󰈈",
	COMMAND = "",
	REPLACE = "󰛔",
	TERMINAL = "",
}

local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		return ""
	end

	local names = {}

	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "󰒋 " .. table.concat(names, ", ")
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",

		--component_separators = {
		--	left = "│",
		--	right = "│",
		--},

		component_separators = {
			left = "",
			right = "",
		},

		section_separators = {
			left = "",
			right = "",
		},

		globalstatus = false,
		always_divide_middle = true,
	},

	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(mode)
					return (mode_icons[mode] or "") .. " " .. mode
				end,
			},
		},
		lualine_b = {
			{
				"branch",
				icon = "",
			},
			{
				"diff",
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
			},
		},
		lualine_c = {
			{
				"filename",
				path = 3,
				symbols = {
					modified = " ●",
					readonly = " ",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			},
		},
		lualine_x = {
			{ -- lsp status
				function()
					return vim.lsp.status()
				end,
				cond = function()
					return vim.lsp.status() ~= ""
				end,
			},
			{ -- attached clients to current buffer
				lsp_clients,
				cond = function()
					return #vim.lsp.get_clients({ bufnr = 0 }) > 0
				end,
			},
			{
				"diagnostics",
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = "󰌵 ",
				},
			},
			"searchcount",
			"selectioncount",
			{
				"filetype",
				icon_only = true,
			},
		},
		lualine_y = {
			"progress",
		},
		lualine_z = {
			"location",
		},
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})

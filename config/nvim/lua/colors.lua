require("cyberdream").setup({
	-- Set light or dark variant
	variant = "dark", -- use "light" for the light variant, "muted" for a softer dark variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
	-- Enable transparent background
	transparent = true,

	-- Reduce the overall saturation of colours for a more muted look
	saturation = 0.75, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

	-- Replace all fillchars with ' ' for the ultimate clean look
	hide_fillchars = true,

	-- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
	borderless_pickers = true,

	-- Set terminal colors used in `:terminal`
	terminal_colors = true,

	-- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
	cache = false,

	overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
		return {
			Comment = { fg = colors.grey, italic = true },
			Type = { fg = colors.purple, bold = true, italic = false },
			["@keyword"] = { fg = colors.orange, italic = true },
			["@function"] = { fg = colors.blue, italic = true },
			["@function.call"] = { fg = colors.blue, bold = true },
			CursorLineNr = { fg = colors.yellow },
			LineNr = { fg = colors.grey },
			LineNrAbove = { fg = colors.grey },
			LineNrBelow = { fg = colors.grey },
		}
	end,

	-- Alternatively, you can use 'default' to set all extensions at once
	extensions = {
		default = true, -- Disable all by default
		base = true, -- Enable all built-in hl groups (you probably want this)
	},
})

vim.cmd.colorscheme("cyberdream")

local dashboard_image
local dashboard_image_width = 32
local dashboard_image_height = 16

require("snacks").setup({
	bigfile = {
		enabled = true,
	},

	dashboard = {
		enabled = true,

		preset = {
			header = table.concat({
				[[                                                                     ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			}, "\n"),

			keys = {
				{
					icon = "󰈔 ",
					key = "<leader>ff",
					label = "SPC f f",
					desc = "Find project file",
					action = ":FzfLua files",
				},
				{
					icon = "󰉋 ",
					key = "<leader>fd",
					label = "SPC f d",
					desc = "Find project directory",
					action = ":Finddir",
				},
				{
					icon = " ",
					key = "<leader>fs",
					label = "SPC f s",
					desc = "Live grep",
					action = ":FzfLua live_grep",
				},
				{
					icon = "󰍔 ",
					key = "<leader>of",
					label = "SPC o f",
					desc = "Find Obsidian note",
					action = function()
						vim.cmd("Obsidian quick_switch")
					end,
				},
				{
					icon = " ",
					key = "<leader>ot",
					label = "SPC o t",
					desc = "Open today's note",
					action = function()
						vim.cmd("Obsidian today")
					end,
				},
				{
					icon = "󰋖 ",
					key = "<leader><leader>h",
					label = "SPC SPC h",
					desc = "Help tags",
					action = ":Telescope help_tags",
				},
				{
					icon = " ",
					key = "q",
					label = "q",
					desc = "Quit",
					action = ":qa",
				},
			},
		},

		sections = {
			{
				pane = 1,

				{ section = "header" },

				--{
				--	text = string.rep("\n", dashboard_image_height - 1),
				--	render = function(self, pos)
				--		if dashboard_image then
				--			dashboard_image:close()
				--		end

				--		local row = pos[1]
				--		local col = pos[2] + math.floor((self.opts.width - dashboard_image_width) / 2)

				--		dashboard_image =
				--			Snacks.image.placement.new(self.buf, vim.fn.expand("~/Pictures/urien-nix.png"), {
				--				pos = { row, col },
				--				range = {
				--					row,
				--					col,
				--					row + dashboard_image_height - 1,
				--					col,
				--				},
				--				width = dashboard_image_width,
				--				height = dashboard_image_height,
				--				conceal = true,
				--				inline = true,
				--				auto_resize = true,
				--			})
				--	end,
				--},

				{ section = "keys", gap = 1, padding = 1 },
			},
		},
	},

	image = {
		enabled = true,
	},

	notifier = {
		enabled = true,
	},

	quickfile = {
		enabled = true,
	},

	statuscolumn = {
		enabled = true,
	},

	words = {
		enabled = true,
	},
})

vim.keymap.set("n", "<leader>D", function()
	Snacks.dashboard()
end, {
	desc = "Snacks - Dashboard",
})

vim.keymap.set("n", "<leader>xn", function()
	Snacks.notifier.show_history()
end, {
	desc = "Snacks - Notification History",
})

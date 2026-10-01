-- ================
-- NOTES
-- ================
-- obsidian.nvim
require("obsidian").setup({
	legacy_commands = false,

	callbacks = {
		enter_note = function(ev)
			vim.opt.conceallevel = 2
		end,
	},

	workspaces = {
		{
			name = "vault",
			path = "~/Documents/cool-vault1/",
		},
	},

	daily_notes = {
		enabled = true,
		folder = "7 - Daily Notes",
		template = "4 - Templates/Daily Note",
		default_tags = { "daily" },
	},
})

vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<CR>", {
	desc = "Obsidian: New note",
})

vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<CR>", {
	desc = "Obsidian: Find notes",
})

vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<CR>", {
	desc = "Obsidian: Search notes",
})

vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<CR>", {
	desc = "Obsidian: Today's daily note",
})

vim.keymap.set("n", "<leader>ow", "<cmd>Obsidian workspace<CR>", {
	desc = "Obsidian: Change workspace",
})

-- markdown-plus
require("markdown-plus").setup({
	features = {
		list_management = true,
		text_formatting = true,
		thematic_break = true,
		links = true,
		images = true,
		headers_toc = true,
		quotes = true,
		callouts = true,
		code_block = true,
		html_block_awareness = true,
		table = true,
		footnotes = true,
	},

	keymaps = {
		enabled = true,
	},

	filetypes = { "markdown" },

	toc = {
		initial_depth = 2,
	},

	thematic_break = {
		style = "---",
	},

	callouts = {
		default_type = "NOTE",
		custom_types = {},
	},

	code_block = {
		enabled = true,
		fence_style = "backtick",
		languages = {
			"lua",
			"python",
			"javascript",
			"typescript",
			"bash",
			"json",
			"yaml",
			"markdown",
		},
	},

	table = {
		enabled = true,
		auto_format = true,
		default_alignment = "left",
		confirm_destructive = true,
		width_mode = "literal",
		wrap_break = "<br>",
		max_column_width = nil,
		auto_wrap = false,

		cell_editor = {
			enabled = true,
			border = "rounded",
			width = 0.6,
			height = 0.4,
		},

		keymaps = {
			enabled = true,
			prefix = "<localleader>t",
			insert_mode_navigation = true,
		},
	},

	footnotes = {
		section_header = "Footnotes",
		confirm_delete = true,
	},

	list = {
		smart_outdent = true,
		whitespace = "single",
		whitespace_width = 4,

		checkbox_completion = {
			enabled = false,
			format = "emoji",
			date_format = "%Y-%m-%d",
			remove_on_uncheck = true,
			update_existing = true,
		},
	},

	links = {
		smart_paste = {
			enabled = false,
			timeout = 5,
		},
	},
})

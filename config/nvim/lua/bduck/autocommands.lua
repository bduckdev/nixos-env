-- Auto reload external changes
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("AutoReloadExternalChanges", { clear = true }),
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
	desc = "Reload externally modified files",
})

-- Nice stuff for markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.formatoptions:append("t")
		vim.opt_local.textwidth = 80
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
		vim.o.conceallevel = 2
	end,
})

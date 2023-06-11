function BetterGx()
	local cmd
	if vim.env.WSLENV then
		vim.cmd("lcd /mnt/c")
		cmd = ":silent !cmd.exe /C start"
	elseif vim.fn.has("win32") or vim.fn.has("win32unix") then
		cmd = ":silent !start"
	elseif vim.fn.executable("xdg-open") then
		cmd = ":silent !xdg-open"
	elseif vim.fn.executable("open") then
		cmd = ":silent !open"
	else
		vim.api.nvim_echo({ { "Can't find proper opener for an URL!", "ErrorMsg" } }, true, {})
		return
	end

	local rx_base = [[\v%((http|ftp|irc)s?|file)://\S]]
	local rx_bare = rx_base .. "+"
	local rx_embd = rx_base .. "-"

	local URL = ""

	local save_view = vim.fn.winsaveview()
	if vim.fn.searchpairpos("\\[.*\\]\\(", "", "\\)", "cbW", "", vim.fn.line(".")) > 0 then
		URL = vim.fn.matchstr(
			vim.fn.getline("."):sub(vim.fn.col(".") - 1),
			"\\[.*\\](\\zs" .. rx_embd .. "\\ze(\\s+.*\\)?"
		)
	end
	vim.fn.winrestview(save_view)

	if URL == "" then
		save_view = vim.fn.winsaveview()
		if vim.fn.searchpairpos(rx_bare .. "\\[", "", "\\]", "cbW", "", vim.fn.line(".")) > 0 then
			URL = vim.fn.matchstr(vim.fn.getline("."):sub(vim.fn.col(".") - 1), "\\S{-}\\ze[")
		end
		vim.fn.winrestview(save_view)
	end

	if URL == "" then
		save_view = vim.fn.winsaveview()
		if vim.fn.searchpairpos("<a%s+href=", "", "\\%(</a>\\|/>\\)\\zs", "cbW", "", vim.fn.line(".")) > 0 then
			URL = vim.fn.matchstr(vim.fn.getline("."):sub(vim.fn.col(".") - 1), "href=[\"']?\\zs\\S{-}\\ze[\"']?/>")
		end
		vim.fn.winrestview(save_view)
	end

	if URL == "" then
		URL = vim.fn.matchstr(vim.fn.expand("<cfile>"), rx_bare)
	end

	if URL == "" then
		return
	end

	vim.api.nvim_command(cmd .. " " .. vim.fn.escape(URL, "#%!"))

	if vim.env.WSLENV then
		vim.cmd("lcd -")
	end
end

vim.keymap.set("n", "gx", BetterGx, {})

local M = {}

M.BetterGx = function()
	local cmd
	if vim.env.WSLENV then
		vim.cmd("lcd /mnt/c")
		cmd = ":silent !cmd.exe /C start"
	elseif vim.fn.has("win32") ~= 0 then
		cmd = ":silent !start"
	elseif vim.fn.executable("xdg-open") ~= 0 then
		cmd = ":silent !xdg-open"
	elseif vim.fn.executable("open") ~= 0 then
		cmd = ":silent !open"
	else
		vim.notify("Can't find proper opener for an URL!", vim.log.levels.ERROR)
		return
	end

	local rx_base = [[\v%((http|ftp|irc)s?|file)://\S]]
	local rx_bare = rx_base .. "+"
	local rx_embd = rx_base .. "-"

	local URL = ""

	-- Markdown URLS
	local save_view = vim.fn.winsaveview()
	local pair_start = vim.fn.searchpairpos("\\[.*\\]\\(", "", "\\)", "cbW", "", vim.fn.line("."))
	if #pair_start > 0 then
		URL = vim.fn.matchstr(
			vim.fn.getline("."):sub(vim.fn.col(".") - 1),
			"\\[.*\\](\\zs" .. rx_embd .. "\\ze(\\s+.*\\))?"
		)
	end
	vim.fn.winrestview(save_view)

	-- AsciiDoc URLS
	if URL == "" then
		save_view = vim.fn.winsaveview()
		pair_start = vim.fn.searchpairpos(rx_bare .. "\\[", "", "\\]", "cbW", "", vim.fn.line("."))
		if #pair_start > 0 then
			URL = vim.fn.matchstr(vim.fn.getline("."):sub(vim.fn.col(".") - 1), "\\S{-}\\ze[")
		end
		vim.fn.winrestview(save_view)
	end

	-- HTML URLS
	if URL == "" then
		save_view = vim.fn.winsaveview()
		pair_start = vim.fn.searchpairpos("<a%s+href=", "", "\\%(</a>\\|/>\\)\\zs", "cbW", "", vim.fn.line("."))
		if #pair_start > 0 then
			URL = vim.fn.matchstr(vim.fn.getline("."):sub(vim.fn.col(".") - 1), "href=[\"']?\\zs\\S{-}\\ze[\"']?/>")
		end
		vim.fn.winrestview(save_view)
	end

	-- Normal URLS
	if URL == "" then
		URL = vim.fn.matchstr(vim.fn.expand("<cfile>"), rx_bare)
	end

	if URL == "" then
		return
	end

	vim.cmd(cmd .. " " .. vim.fn.escape(URL, "#%!"))

	if vim.env.WSLENV then
		vim.cmd("lcd -")
	end
end

return M

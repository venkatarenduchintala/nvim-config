-- Plug-n-play theme system.
--
-- Each colorscheme lives in its own file under lua/themes/<name>.lua and returns
-- a lazy.nvim plugin spec. To add a theme: drop a new file in lua/themes/ — no
-- edits here required. To switch: `:Theme <name>` (persists across restarts) or
-- set the default in lua/settings.lua via set_active_theme(...).
--
-- Only the *active* theme plugin is installed (get_active_theme marks it
-- lazy=false / priority=1000); the others are never fetched, keeping startup lean.

local M = {}

-- Fixed accent palette consumed by some plugin configs (bufferline, scrollbar).
-- Independent of the active colorscheme.
M.colors = {
	bg = "#2e3440",
	fg = "#ECEFF4",
	red = "#bf616a",
	orange = "#d08770",
	yellow = "#ebcb8b",
	blue = "#5e81ac",
	green = "#a3be8c",
	cyan = "#88c0d0",
	magenta = "#b48ead",
	purple = "#534671",
	pink = "#FFA19F",
	grey1 = "#f8fafc",
	grey2 = "#f0f1f4",
	grey3 = "#eaecf0",
	grey4 = "#d9dce3",
	grey5 = "#c4c9d4",
	grey6 = "#b5bcc9",
	grey7 = "#929cb0",
	grey8 = "#8e99ae",
	grey9 = "#74819a",
	grey10 = "#616d85",
	grey11 = "#464f62",
	grey12 = "#3a4150",
	grey13 = "#333a47",
	grey14 = "#242932",
	grey15 = "#1e222a",
	grey16 = "#1c1f26",
	grey17 = "#0f1115",
	grey18 = "#0d0e11",
	grey19 = "#020203",
}

-- Machine-local persisted choice (not tracked in the repo).
local state_file = vim.fn.stdpath("data") .. "/active-theme.txt"

-- Discover available theme names from lua/themes/*.lua on the runtimepath.
function M.list()
	local seen, names = {}, {}
	for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/themes/*.lua", true)) do
		local name = vim.fn.fnamemodify(path, ":t:r")
		if not seen[name] then
			seen[name] = true
			names[#names + 1] = name
		end
	end
	table.sort(names)
	return names
end

local function is_valid(name)
	for _, n in ipairs(M.list()) do
		if n == name then
			return true
		end
	end
	return false
end

local function read_persisted()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local name = vim.trim(f:read("*a") or "")
	f:close()
	return name ~= "" and name or nil
end

local function write_persisted(name)
	local f = io.open(state_file, "w")
	if not f then
		return false
	end
	f:write(name)
	f:close()
	return true
end

-- Default theme, set from lua/settings.lua. A persisted `:Theme` choice wins.
function M.set_active_theme(name)
	M.default_theme = name
	if not M.theme_name then
		M.theme_name = name
	end
end

local function resolve_name()
	local persisted = read_persisted()
	if persisted and is_valid(persisted) then
		return persisted
	end
	if M.default_theme and is_valid(M.default_theme) then
		return M.default_theme
	end
	return M.default_theme or M.list()[1]
end

-- Returns the lazy.nvim spec for the active theme (the only one that gets installed).
function M.get_active_theme()
	local name = resolve_name()
	M.theme_name = name
	local ok, spec = pcall(require, "themes." .. name)
	if not ok or type(spec) ~= "table" then
		vim.notify("theme: failed to load 'themes." .. tostring(name) .. "': " .. tostring(spec), vim.log.levels.ERROR)
		return {}
	end
	spec.lazy = false
	spec.priority = 1000
	return spec
end

-- :Theme            -> show current + available
-- :Theme <name>     -> persist choice (restart to apply; only active is installed)
vim.api.nvim_create_user_command("Theme", function(opts)
	local name = vim.trim(opts.args)
	local themes = M.list()
	if name == "" then
		vim.notify(
			"Active theme: " .. (M.theme_name or "?") .. "\nAvailable: " .. table.concat(themes, ", "),
			vim.log.levels.INFO
		)
		return
	end
	if not is_valid(name) then
		vim.notify("Unknown theme '" .. name .. "'. Available: " .. table.concat(themes, ", "), vim.log.levels.ERROR)
		return
	end
	if write_persisted(name) then
		vim.notify(
			"Theme set to '" .. name .. "'. Restart Neovim to apply (it installs on next launch).",
			vim.log.levels.INFO
		)
	else
		vim.notify("Could not write theme choice to " .. state_file, vim.log.levels.ERROR)
	end
end, {
	nargs = "?",
	desc = "Show or switch the active colorscheme (restart-based)",
	complete = function(arglead)
		local out = {}
		for _, n in ipairs(M.list()) do
			if n:find(arglead, 1, true) == 1 then
				out[#out + 1] = n
			end
		end
		return out
	end,
})

return M

-- Handles monitor setup and workspace assignment
local builtin = "eDP-1"
local asus_27inch_5k = "ASUSTek COMPUTER INC XG27JCG"
local asus_16inch_hd = "ASUSTek COMPUTER INC MQ16FC"

local M = {
	main = builtin,
}

-- sets up persistent workspaces. secondary_monitor is optional
local function set_workspaces(main_monitor, secondary_monitor)
	for i = 1, 10 do
		hl.workspace_rule({ monitor = main_monitor, workspace = tostring(i), persistent = true })
	end

	if secondary_monitor == nil then
		return
	end

	for i = 11, 13 do
		hl.workspace_rule({ monitor = secondary_monitor, workspace = tostring(i), persistent = true })
	end
end

function M.update()
	-- would be better if it could also handle case with laptop and 1 monitor
	local docked = false
	local hyprland_monitors = hl.get_monitors({ all = true })
	for _, monitor in ipairs(hyprland_monitors) do
		if monitor.description:find(asus_27inch_5k, 1, true) then
			docked = true
			M.main = "desc:" .. asus_27inch_5k
			break
		else
			docked = false
			M.main = builtin
		end
	end

	hl.monitor({ output = builtin, disabled = docked })

	set_workspaces(M.main)
end

function M.setup()
	hl.monitor({
		output = "desc:" .. asus_27inch_5k,
		mode = "5120x2880@120",
		position = "auto",
		scale = "2",
	})

	hl.monitor({
		output = "desc:" .. asus_16inch_hd,
		disabled = true,
		mode = "1920x1200@60",
		position = "auto",
		scale = "1",
		transform = 0,
	})

	hl.monitor({
		output = builtin,
		mode = "1920x1080@60",
		position = "auto",
		scale = "1",
	})

	hl.on("monitor.added", M.update)
	hl.on("monitor.removed", M.update)

	M.update()
end

return M

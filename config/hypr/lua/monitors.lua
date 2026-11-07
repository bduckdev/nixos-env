-- Handles monitor setup and workspace assignment
local builtin = "eDP-1"
local asus_27inch_5k = "desc:ASUSTek COMPUTER INC XG27JCG"
local asus_16inch_hd = "desc:ASUSTek COMPUTER INC MQ16FC"

local Monitors = {
	primary = builtin,
	secondary = asus_16inch_hd,
	secondary_enabled = false,
}

-- sets up persistent workspaces. secondary_monitor is optional
local function set_workspaces(primary_monitor, secondary_monitor)
	for i = 1, 10 do
		hl.workspace_rule({ monitor = primary_monitor, workspace = tostring(i), default = i == 3, persistent = true })
	end

	if secondary_monitor == nil then
		return
	end

	for i = 11, 12 do
		hl.workspace_rule({ monitor = secondary_monitor, workspace = tostring(i), persistent = true })
	end
end

function Monitors.update()
	local docked = false
	local hyprland_monitors = hl.get_monitors({ all = true })

	for _, monitor in ipairs(hyprland_monitors) do
		-- it would be nicer to check for caldigit, but checking for asus is fine
		if monitor.description:find(asus_27inch_5k, 1, true) then
			docked = true
			break
		end
	end

	if docked then
		Monitors.primary = asus_27inch_5k
	else
		Monitors.primary = builtin
	end

	hl.monitor({ output = builtin, disabled = docked })

	if Monitors.secondary_enabled then
		set_workspaces(Monitors.primary, Monitors.secondary)
	else
		set_workspaces(Monitors.primary, nil)
	end
end

function Monitors.setup(hostname)
	if hostname == "nixos-desktop" then
		hl.monitor({
			output = "STREAM",
			mode = "1920x1080@60",
			position = "auto",
			scale = 1,
		})
	elseif hostname == "nixos-laptop" then
		hl.monitor({
			output = builtin,
			mode = "1920x1200@60",
			position = "auto",
			scale = 1,
		})
	end

	hl.monitor({
		output = asus_27inch_5k,
		mode = "5120x2880@120",
		position = "auto",
		scale = 2,
	})

	hl.monitor({
		output = asus_16inch_hd,
		disabled = not Monitors.secondary_enabled,
		mode = "1920x1200@60",
		position = "auto",
		scale = 1.25,
		transform = 1,
	})

	hl.on("monitor.added", Monitors.update)
	hl.on("monitor.removed", Monitors.update)

	Monitors.update()
end

return Monitors

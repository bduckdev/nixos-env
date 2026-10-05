-- workspaces. should be decoupled from monitors ideally. sets workspaces for main monitor
local Workspaces = {}

function Workspaces.setup(main, secondary)
	for i = 1, 10 do
		hl.workspace_rule({ monitor = main, workspace = tostring(i), persistent = true })
	end

	if secondary == nil then
		return
	end

	for i = 11, 13 do
		hl.workspace_rule({ monitor = secondary, workspace = tostring(i), persistent = true })
	end
end

return Workspaces

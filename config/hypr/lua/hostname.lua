-- gets hostname for setting up other stuff
local hosts = {
	["nixos-laptop"] = true,
	["nixos-desktop"] = true,
}
local file = assert(io.open("/etc/hostname", "r"))
local hostname = file:read("*l")
file:close()
assert(hosts[hostname], "Hyprland not configured for current host: " .. tostring(hostname))
return hostname

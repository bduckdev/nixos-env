local file = assert(io.open("/etc/hostname", "r"))
local hostname = file:read("*l")
file:close()
return hostname

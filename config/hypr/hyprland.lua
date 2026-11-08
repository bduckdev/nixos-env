local hostname = require("lua/hostname")
local monitors = require("lua/monitors")
monitors.setup(hostname)

-- AUTOSTART
hl.on("hyprland.start", function()
	if hostname == "nixos-desktop" then
		hl.exec_cmd("hyprctl output create headless STREAM")
	end

	-- I could do launching apps at startup like this, but i don't want to enable xp waste
	for _, app in ipairs({ "kitty", "firefox", "obsidian" }) do
		hl.exec_cmd(app)
	end
end)

-- ENVIRONMENT VARIABLES
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- CONFIG
local want_gaps = true
hl.config({
	general = {
		gaps_in = want_gaps and 5 or 0,
		gaps_out = want_gaps and 10 or 0,

		border_size = 2,

		resize_on_border = false,

		allow_tearing = false,

		layout = "dwindle",
	},

	debug = {
		disable_logs = true,
	},

	misc = {
		disable_autoreload = false,
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
		disable_splash_rendering = true,
		force_default_wallpaper = 1, -- Set to 0 or 1 to disable the anime mascot wallpapers
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 8,
			passes = 2,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	-- makes windows members of b-tree like bspwm
	dwindle = {
		preserve_split = true,
	},

	-- master stack like dwm
	master = {
		new_status = "master",
	},

	-- scrolling like niri
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

hl.config({})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- thinkpad trackpoint
hl.device({
	name = "tpps/2-elan-trackpoint",
	scroll_method = "on_button_down",
	scroll_button = 274, -- middle mouse button
	scroll_button_lock = false,
})

require("lua/keybinds")

-- animations
require("lua/animations/fluid")

-- rules for workspace assignments, etc.
require("lua/rules")

-- For Noctalia Color templates
require("noctalia").apply_theme()

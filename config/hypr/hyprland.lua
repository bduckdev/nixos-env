local mod = "SUPER"
local ipc = "noctalia msg "

-- ============================================================================
-- ENVIRONMENT
-- ============================================================================

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- ============================================================================
-- MONITORS
-- ============================================================================

-- 27" 5K
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC XG27JCG",
	mode = "5120x2880@120",
	position = "0x0",
	scale = 2,
})

-- 16" portable, vertical
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC MQ16FC",
	mode = "1920x1200@60",
	position = "auto-right",
	scale = 1,
	transform = 1,
})

-- ThinkPad internal display.
--
-- auto-right is intentional:
--   laptop alone -> effectively 0x0
--   docked       -> goes to the right of the external displays
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "auto-right",
	scale = 1,
})

-- Unknown displays should at least come up sanely.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-right",
	scale = 1,
})

-- ============================================================================
-- CORE
-- ============================================================================

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 10,
		border_size = 3,

		layout = "master",

		resize_on_border = true,
		allow_tearing = false,
	},

	decoration = {
		rounding = 6,

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
			size = 7,
			passes = 2,
			vibrancy = 0.17,
		},
	},

	animations = {
		enabled = true,
	},

	master = {
		mfact = 0.55,
		new_status = "master",
	},

	input = {
		kb_layout = "us",

		repeat_rate = 25,
		repeat_delay = 600,

		numlock_by_default = false,

		-- Mango sloppyfocus = 1
		follow_mouse = 1,

		natural_scroll = false,

		touchpad = {
			tap_to_click = true,
			tap_and_drag = true,
			drag_lock = 1,
			natural_scroll = false,
		},
	},

	cursor = {
		warp_on_change_workspace = 1,
	},

	-- Noctalia owns the desktop/wallpaper.
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

-- ============================================================================
-- ANIMATIONS
-- ============================================================================

-- 1.0 = default
-- > 1.0 = faster
-- < 1.0 = slower
local animationSpeed = 0.25

local function speed(base)
	return base * animationSpeed
end

hl.curve("snappy", {
	type = "bezier",
	points = {
		{ 0.20, 0.90 },
		{ 0.20, 1.00 },
	},
})

hl.curve("workspace", {
	type = "bezier",
	points = {
		{ 0.22, 0.75 },
		{ 0.18, 1.00 },
	},
})

hl.curve("windowSpring", {
	type = "spring",
	mass = 1,
	stiffness = 320,
	dampening = 32,
})

hl.animation({
	leaf = "global",
	enabled = true,
	speed = speed(10),
	bezier = "snappy",
})

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = speed(8),
	spring = "windowSpring",
})

hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = speed(8),
	spring = "windowSpring",
	style = "popin 94%",
})

hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = speed(10),
	bezier = "snappy",
	style = "popin 96%",
})

hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = speed(8),
	bezier = "workspace",
	style = "slide",
})

hl.animation({
	leaf = "fade",
	enabled = true,
	speed = speed(10),
	bezier = "snappy",
})

hl.animation({
	leaf = "border",
	enabled = true,
	speed = speed(10),
	bezier = "snappy",
})

hl.animation({
	leaf = "layers",
	enabled = false,
})
-- ============================================================================
-- STARTUP
-- ============================================================================

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")

	-- Preserve your current "start on 3 and open kitty" behavior.
	hl.dispatch(hl.dsp.focus({ workspace = 3 }))
	hl.exec_cmd("kitty -e zsh")
end)

-- ============================================================================
-- WINDOW RULES
-- ============================================================================

local function app_to_workspace(class, workspace)
	hl.window_rule({
		match = {
			class = class,
		},

		workspace = tostring(workspace) .. " silent",
	})
end

app_to_workspace("^helium$", 4)
app_to_workspace("^md%.obsidian$", 5)
app_to_workspace("^org%.telegram%.desktop$", 7)
app_to_workspace("^discord$", 8)
app_to_workspace("^steam$", 9)
app_to_workspace("^stremio$", 9)
app_to_workspace("^spotify$", 10)

-- Your Mango tag 6 "open as floating" behavior.
hl.window_rule({
	match = {
		workspace = "6",
	},

	float = true,
})

-- Your no_border_when_single behavior.
hl.window_rule({
	match = {
		float = false,
		workspace = "w[tv1]s[false]",
	},

	border_size = 0,
})

-- Noctalia settings window.
hl.window_rule({
	match = {
		class = "^dev%.noctalia%.Noctalia$",
	},

	float = true,
	size = { 1080, 920 },
})

-- ============================================================================
-- NOCTALIA
-- ============================================================================

-- Hyprland supplies blur to Noctalia surfaces.
-- Noctalia handles their own animations.
hl.layer_rule({
	name = "noctalia",

	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},

	no_anim = true,
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

-- ============================================================================
-- SCREENSHOTS
-- ============================================================================

hl.bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen all"))

hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

-- ============================================================================
-- LAUNCHER / TERMINAL
-- ============================================================================

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"))

hl.bind(mod .. " + D", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

-- ============================================================================
-- WINDOW FOCUS
-- ============================================================================

hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mod .. " + TAB", hl.dsp.window.cycle_next({ next = true }))

-- Let Noctalia own the fancy switcher.
hl.bind("ALT + TAB", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))

-- ============================================================================
-- WINDOW SWAPPING
-- ============================================================================

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))

hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))

hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))

hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

-- ============================================================================
-- WINDOW STATE
-- ============================================================================

hl.bind(mod .. " + backslash", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

hl.bind(
	mod .. " + A",
	hl.dsp.window.fullscreen({
		mode = "maximized",
		action = "toggle",
	})
)

hl.bind(
	mod .. " + F",
	hl.dsp.window.fullscreen({
		mode = "fullscreen",
		action = "toggle",
	})
)

-- Closest equivalent to fake fullscreen.
hl.bind(
	mod .. " + SHIFT + F",
	hl.dsp.window.fullscreen_state({
		internal = 0,
		client = 2,
		action = "toggle",
	})
)

-- Closest equivalent to Mango "global".
hl.bind(mod .. " + G", hl.dsp.window.pin({ action = "toggle" }))

-- ============================================================================
-- SCRATCHPAD
-- ============================================================================

hl.bind(mod .. " + Z", hl.dsp.workspace.toggle_special("scratchpad"))

hl.bind(
	mod .. " + SHIFT + Z",
	hl.dsp.window.move({
		workspace = "special:scratchpad",
		follow = false,
	})
)

-- ============================================================================
-- MINIMIZE
-- ============================================================================

-- Hyprland intentionally doesn't have traditional minimizing, so use a hidden
-- special workspace while preserving your SUPER+I / SUPER+SHIFT+I workflow.

hl.bind(mod .. " + I", function()
	local w = hl.get_active_window()

	if not w then
		return
	end

	hl.dispatch(hl.dsp.window.tag({
		window = w,
		tag = "minimized",
	}))

	hl.dispatch(hl.dsp.window.move({
		window = w,
		workspace = "special:minimized",
		follow = false,
	}))
end)

hl.bind(mod .. " + SHIFT + I", function()
	local workspace = hl.get_active_workspace()

	if not workspace then
		return
	end

	hl.dispatch(hl.dsp.window.move({
		window = "tag:minimized",
		workspace = workspace,
		follow = false,
	}))

	hl.dispatch(hl.dsp.window.clear_tags({
		window = "tag:minimized",
	}))
end)

-- ============================================================================
-- WORKSPACES
-- ============================================================================

hl.bind(mod .. " + P", hl.dsp.focus({ workspace = "m-1" }))

hl.bind(mod .. " + N", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(mod .. " + grave", hl.dsp.focus({ workspace = "previous_per_monitor" }))

for i = 1, 10 do
	local key = i % 10

	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ============================================================================
-- MONITORS
-- ============================================================================

hl.bind(mod .. " + M", hl.dsp.focus({ monitor = "+1" }))

hl.bind(
	mod .. " + SHIFT + M",
	hl.dsp.window.move({
		monitor = "+1",
		follow = true,
	})
)

-- Equivalent to your Mango axis binds.
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- ============================================================================
-- FLOATING WINDOW MOVEMENT
-- ============================================================================

hl.bind("CTRL + SHIFT + up", hl.dsp.window.move({ x = 0, y = -50, relative = true }), { repeating = true })

hl.bind("CTRL + SHIFT + down", hl.dsp.window.move({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind("CTRL + SHIFT + left", hl.dsp.window.move({ x = -50, y = 0, relative = true }), { repeating = true })

hl.bind("CTRL + SHIFT + right", hl.dsp.window.move({ x = 50, y = 0, relative = true }), { repeating = true })

-- ============================================================================
-- FLOATING WINDOW RESIZE
-- ============================================================================

hl.bind("CTRL + ALT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })

hl.bind("CTRL + ALT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

hl.bind("CTRL + ALT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })

hl.bind("CTRL + ALT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- ============================================================================
-- MOUSE
-- ============================================================================

hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ============================================================================
-- RESIZE MODE
-- ============================================================================

hl.bind(mod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })

	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

	hl.bind("RETURN", hl.dsp.submap("reset"))
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("ALT + R", hl.dsp.submap("reset"))
end)

-- ============================================================================
-- SESSION
-- ============================================================================

--hl.bind("ALT + SHIFT + C", hl.dsp.reload_config())

--hl.bind("ALT + R", hl.dsp.reload_config())

hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprshutdown"))

-- ============================================================================
-- NOCTALIA HARDWARE CONTROLS
-- ============================================================================

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "mic-mute"), { locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })

hl.bind("XF86Display", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center monitor"))

hl.bind("XF86WLAN", hl.dsp.exec_cmd(ipc .. "wifi-toggle"))

hl.bind("XF86NotificationCenter", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications"))

hl.bind("XF86Favorites", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

-- ============================================================================
-- NOCTALIA THEME
-- ============================================================================

-- Noctalia's built-in Hyprland template creates:
--   ~/.config/hypr/noctalia.lua
--
-- The explicit require("noctalia") text is also important because Noctalia's
-- template installer uses it to recognize that integration is already present.

local noctalia_ok, noctalia = pcall(function()
	return require("noctalia")
end)

if noctalia_ok then
	noctalia.apply_theme()
end

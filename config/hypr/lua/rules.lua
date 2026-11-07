--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
--hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-gaps-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
--
--hl.window_rule({
--	name = "no-gaps-f1",
--	match = { float = false, workspace = "f[1]" },
--	border_size = 0,
--	rounding = 0,
--})

hl.window_rule({
	name = "workspace-1-floating",
	match = {
		workspace = "1",
	},
	float = true,
})
hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})
hl.window_rule({
	match = { class = "^helium$" },
	workspace = "4 silent",
})
hl.window_rule({
	match = { class = "^firefox$" },
	workspace = "4 silent",
})
hl.window_rule({
	match = { class = "^md.obsidian.Obsidian$" },
	workspace = "5 silent",
})
hl.window_rule({
	match = { class = "^proton.vpn.app.gtk$" },
	workspace = "6 silent",
})
hl.window_rule({
	match = { class = "^com.moonlight_stream.Moonlight$" },
	workspace = "8",
})
hl.window_rule({
	match = { class = "^org.telegram.desktop$" },
	workspace = "9 silent",
	float = false,
	size = { 750, 650 },
	move = { 1100, 150 },
})
hl.window_rule({
	match = { class = "^discord$" },
	workspace = "9 silent",
	float = false,
	--size = { 1000, 900 },
	--move = { 50, 70 },
})
hl.window_rule({
	match = { class = "^Spotify$" },
	workspace = "10 silent",
})

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

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

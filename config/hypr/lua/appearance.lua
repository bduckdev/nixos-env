local A = {
	use_fancy_animations_and_gaps = false,
}

function A.setup()
	hl.config({
		general = {
			border_size = A.use_fancy_animations_and_gaps and 2 or 1,
			gaps_in = A.use_fancy_animations_and_gaps and 5 or 0,
			gaps_out = A.use_fancy_animations_and_gaps and 10 or 0,

			resize_on_border = false,

			allow_tearing = false,
		},
		decoration = {
			rounding = 0,
			rounding_power = 2,

			-- Change transparency of focused and unfocused windows
			active_opacity = 1.0,
			inactive_opacity = 1.0,

			shadow = {
				enabled = A.use_fancy_animations_and_gaps,
				range = 4,
				render_power = 3,
				color = 0xee1a1a1a,
			},

			blur = {
				enabled = A.use_fancy_animations_and_gaps,
				size = 5,
				passes = 2,
				new_optimizations = true,
				vibrancy = 0.1696,
			},
		},

		animations = {
			enabled = A.use_fancy_animations_and_gaps,
		},
	})
end

function A.toggle_fancy_animations_and_gaps()
	A.use_fancy_animations_and_gaps = not A.use_fancy_animations_and_gaps
	A.setup()
end

return A

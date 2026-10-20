-- General settings
swayimg.dnd_button = "MouseMiddle"
swayimg.gallery.pstore = true
swayimg.gallery.cache = 200
swayimg.gallery.preload = true
swayimg.gallery.thumb_size = 150
swayimg.gallery.embedded_thumb = true
swayimg.fullscreen = true
swayimg.viewer.default_scale = "fit"
swayimg.viewer.default_position = "center"

-- Image list
swayimg.imagelist.adjacent = true
swayimg.imagelist.order = "numeric"

-- Always-visible information overlay
swayimg.text.visible = true
swayimg.text.timeout = 0

-- Viewer text
swayimg.viewer.set_text("bottomleft", {
	"{path}",
})

swayimg.viewer.set_text("topright", {
	"{list.index} / {list.total}",
})

-- Gallery text
swayimg.gallery.set_text("bottomleft", {
	"{path}",
})

swayimg.gallery.set_text("topright", {
	"{list.index} / {list.total}",
})

-- Viewer: next/previous images
swayimg.viewer.on_key("n", function()
	swayimg.viewer.open("next")
end)

swayimg.viewer.on_key("p", function()
	swayimg.viewer.open("prev")
end)

-- Viewer: open gallery
swayimg.viewer.on_key("Return", function()
	swayimg.mode = "gallery"
end)

-- Gallery: Vim navigation
swayimg.gallery.on_key("h", function()
	swayimg.gallery.select("left")
end)

swayimg.gallery.on_key("j", function()
	swayimg.gallery.select("down")
end)

swayimg.gallery.on_key("k", function()
	swayimg.gallery.select("up")
end)

swayimg.gallery.on_key("l", function()
	swayimg.gallery.select("right")
end)

-- Gallery: first/last image
swayimg.gallery.on_key("g", function()
	swayimg.gallery.select("first")
end)

swayimg.gallery.on_key("Shift+g", function()
	swayimg.gallery.select("last")
end)

-- Gallery: page navigation
swayimg.gallery.on_key("Ctrl+d", function()
	swayimg.gallery.select("pgdown")
end)

swayimg.gallery.on_key("Ctrl+u", function()
	swayimg.gallery.select("pgup")
end)

-- Gallery: next/previous
swayimg.gallery.on_key("n", function()
	swayimg.gallery.select("right")
end)

swayimg.gallery.on_key("p", function()
	swayimg.gallery.select("left")
end)

-- Gallery: open selected image
swayimg.gallery.on_key("Return", function()
	swayimg.mode = "viewer"
end)

-- Quit from either mode
swayimg.viewer.on_key("q", function()
	swayimg.exit()
end)

swayimg.gallery.on_key("q", function()
	swayimg.exit()
end)

-- Right-click to open gallery
swayimg.viewer.on_mouse("MouseRight", function()
	swayimg.mode = "gallery"
end)

-- Right-click in gallery to return to viewer
swayimg.gallery.on_mouse("MouseRight", function()
	swayimg.mode = "viewer"
end)

-- Viewer: scroll to change images
swayimg.viewer.on_mouse("ScrollUp", function()
	swayimg.viewer.open("prev")
end)

swayimg.viewer.on_mouse("ScrollDown", function()
	swayimg.viewer.open("next")
end)

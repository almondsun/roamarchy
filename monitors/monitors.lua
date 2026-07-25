-- Portable scale-1 baseline. The runtime watcher selects the best advertised
-- mode and deterministic positions when an external display is connected.
hl.env("GDK_SCALE", "1")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

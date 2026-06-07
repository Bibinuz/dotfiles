hl.window_rule({
  name = "Godot-tile",
  match = {
    class = "^(Godot)$",
    title = "^(Godot)$"
  },
  tile = true
})

hl.window_rule({
  name = "debug-centered",
  match = {
    title = "^.*(\\(DEBUG\\))$",
    initial_title = "^(Godot)$"
  },
  float = true,
  center = true,
  size = {1920, 1080}
})

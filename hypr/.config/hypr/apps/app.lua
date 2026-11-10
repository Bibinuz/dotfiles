require("apps.waypaper")
require("apps.bluetui")
require("apps.wifi")
require("apps.volumecontrol")
require("apps.godot")
require("apps.btop")
require("apps.vulkanapp")

hl.window_rule({
      name = "suppress-maximize",
      match = {
        class = ".*"       },
      suppress_event = "maximize"
    })

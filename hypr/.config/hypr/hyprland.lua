-- Files needed
require("lookandfeel")
require("input")
require("keybinds")
require("monitors")
require("apps.app")

-- Default apps

Terminal = "kitty"
FileManager = "nautilus"
Menu = "quickshell ipc call launcher toggle"
TextEditor = "gedit"
Browser = "waterfox"
Bar = "quickshell"

-- Auto start

hl.on("hyprland.start", function ()
    hl.exec_cmd(Bar)
    hl.exec_cmd("swaync")
    hl.exec_cmd("awww-daemon & awww restore")
    hl.exec_cmd("hypridle")
end)

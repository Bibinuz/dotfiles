require("defaults")

Main = "SUPER"

local function exec_cmd(keys, thing)
    hl.bind(keys, hl.dsp.exec_cmd(thing))
end

-- Open apps

exec_cmd(Main .. "+ return", Terminal)
exec_cmd(Main .. "+ space", "pkill " .. MenuApp .. " || " .. Menu)
exec_cmd(Main .. "+ B", "pkill " .. Bar .. " || " .. Bar)
exec_cmd(Main .. "+ SHIFT + space", "quickshell ipc call wallpaper toggle")
exec_cmd(Main .. "+ SHIFT + F", FileManager)
exec_cmd(Main .. "+ SHIFT + T", TextEditor)
exec_cmd(Main .. "+ SHIFT + B", Browser)
exec_cmd(Main .. "+ SHIFT + S", "steam")
exec_cmd(Main .. "+ SHIFT + CONTROL + S", "spotify-launcher")

exec_cmd(Main .. "+ SHIFT + A", "~/.config/hypr/scripts/launch-webapp.sh \"https://gemini.google.com\"")
exec_cmd(Main .. "+ SHIFT + G", "~/.config/hypr/scripts/launch-webapp.sh \"https://github.com/Bibinuz\"")

exec_cmd(Main .. "+ SHIFT + L", "hyprlock")
exec_cmd(Main .. "+ SHIFT + P", "hyprpicker")
exec_cmd(Main .. "+ ESCAPE", "pkill wlogout || wlogout")

exec_cmd("PRINT", "hyprshot -m window")
exec_cmd("SHIFT + PRINT", "hyprshot -m region")

-- General commands

hl.bind(Main .. " + W", hl.dsp.window.close())
hl.bind(Main .. " + ALT + M", hl.dsp.exit())
hl.bind(Main .. " + V", hl.dsp.window.float())
hl.bind(Main .. " + F", hl.dsp.window.fullscreen())
hl.bind(Main .. " + P", hl.dsp.window.pin())

-- Scrolling keybinds

hl.bind(Main .. "+ PERIOD", hl.dsp.layout("move +col"))
hl.bind(Main .. "+ COMMA", hl.dsp.layout("move -col"))
hl.bind(Main .. "+ SHIFT + PERIOD", hl.dsp.layout("swapcol r"))
hl.bind(Main .. "+ SHIFT + COMMA", hl.dsp.layout("swapcol l"))
hl.bind(Main .. "+ ALT + PERIOD", hl.dsp.layout("colresize +0.1"))
hl.bind(Main .. "+ ALT + COMMA", hl.dsp.layout("colresize -0.1"))

-- Navigation keybinds

hl.bind(Main .. "+ LEFT", hl.dsp.focus({direction = "left"}))
hl.bind(Main .. "+ RIGHT", hl.dsp.focus({direction = "right"}))
hl.bind(Main .. "+ UP", hl.dsp.focus({direction = "up"}))
hl.bind(Main .. "+ DOWN", hl.dsp.focus({ direction = "down" }))

hl.bind(Main .. "+ 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(Main .. "+ 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(Main .. "+ 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(Main .. "+ 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(Main .. "+ 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(Main .. "+ 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(Main .. "+ 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(Main .. "+ 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(Main .. "+ 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(Main .. "+ 0", hl.dsp.focus({ workspace = "10" }))

hl.bind(Main .. "+ mouse_down", hl.dsp.focus({workspace = "e-1"}))
hl.bind(Main .. "+ mouse_up", hl.dsp.focus({workspace = "e+1"}))

-- Window movement

hl.bind(Main .. "+ SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(Main .. "+ SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(Main .. "+ SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(Main .. "+ SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))

hl.bind(Main .. "+ SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(Main .. "+ SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(Main .. "+ SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(Main .. "+ SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(Main .. "+ SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind(Main .. "+ SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind(Main .. "+ SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind(Main .. "+ SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind(Main .. "+ SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind(Main .. "+ SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

hl.bind(Main .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(Main .. "+ CTRL", hl.dsp.window.drag(), { mouse = true })

-- Resize windows

local n = 20

hl.bind(Main .. "+ ALT + right", hl.dsp.window.resize({ x = n, y = 0, relative = true }), { repeating = true })
hl.bind(Main .. "+ ALT + left",  hl.dsp.window.resize({ x = -n, y = 0, relative = true }), { repeating = true })
hl.bind(Main .. "+ ALT + up",    hl.dsp.window.resize({ x = 0, y = -n, relative = true }), { repeating = true })
hl.bind(Main .. "+ ALT + down",  hl.dsp.window.resize({ x = 0, y = n, relative = true }), { repeating = true })

hl.bind(Main .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(Main .. "+ ALT", hl.dsp.window.resize(), { mouse = true })

-- Volume

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Brightness

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, locked = true })

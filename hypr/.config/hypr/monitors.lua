local function get_chassis()
	-- Method 1: Read sysfs DMI chassis_type (instant, no subprocess overhead)
	local file = io.open("/sys/class/dmi/id/chassis_type", "r")
	if file then
		local code = tonumber(file:read("*l"))
		file:close()
		-- DMI chassis codes for laptops/portables:
		-- 8=Portable, 9=Laptop, 10=Notebook, 11=Handheld, 14=Sub-Notebook, 30=Tablet, 31=Convertible, 32=Detachable
		if
			code
			and (
				code == 8
				or code == 9
				or code == 10
				or code == 11
				or code == 14
				or code == 30
				or code == 31
				or code == 32
			)
		then
			return "laptop"
		end
	end

	-- Method 2: Fallback to systemd hostnamectl chassis
	local handle = io.popen("hostnamectl chassis 2>/dev/null")
	if handle then
		local result = handle:read("*l")
		handle:close()
		if result and #result > 0 then
			return result:gsub("%s+", "")
		end
	end

	return "desktop"
end

local chassis = get_chassis()

if chassis == "laptop" then
	-- Laptop screen
	hl.monitor({ output = "eDP-1", mode = "prefered", position = "300x1080", scale = "1.57" })
	-- External monitors connected to laptop
	hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "0x0", scale = "1" })
	hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60", position = "0x0", scale = "2" })

	-- Workspace rules for laptop (if needed)
	hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
else
	-- Desktop monitors
	hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "1080x200", scale = "1" })
	hl.monitor({ output = "DP-2", mode = "1920x1080@144", position = "0x0", scale = "1", transform = 3 })

	-- Workspace rules for desktop
	hl.workspace_rule({ workspace = "1", monitor = "DP-2" })
	hl.workspace_rule({ workspace = "2", monitor = "DP-1", default = true })
	hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "6", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "7", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "8", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "9", monitor = "DP-1" })
	hl.workspace_rule({ workspace = "10", monitor = "DP-2" })
end

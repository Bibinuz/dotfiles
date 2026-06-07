local matugen = require("colors")

hl.config({
    general = {
        border_size      = 2,
        col = {
            active_border   = { colors = { matugen.primary, matugen.secondary }, angle = 45 },
            inactive_border = matugen.outline,
        },
        resize_on_border = true,
        gaps_in          = 1,
        gaps_out         = 0,
        layout           = "scrolling",
        allow_tearing    = false,
    },

    dwindle = {
        preserve_split = true,
    },

    decoration = {
        rounding         = 4,
        inactive_opacity = 0.85,
        blur = {
            enabled           = true,
            size              = 5,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
        },
    },

    animations = {
        enabled = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Bezier curves (replaces: bezier = name, p1x, p1y, p2x, p2y)
hl.curve("wind",       { type = "bezier", points = { {0.05, 0.9},  {0.1,  1.05} } })
hl.curve("winIn",      { type = "bezier", points = { {0.1,  1.1},  {0.1,  1.1}  } })
hl.curve("winOut",     { type = "bezier", points = { {0.3,  -0.3}, {0,    1}    } })
hl.curve("liner",      { type = "bezier", points = { {1,    1},    {1,    1}    } })
hl.curve("workswitch", { type = "bezier", points = { {0.04, 0.27}, {0.58, 1}    } })

-- Animations (replaces: animation = name, enabled, speed, bezier[, style])
hl.animation({ leaf = "windows",     enabled = true, speed = 3,  bezier = "wind",       style = "slide"    })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4,  bezier = "winIn",      style = "slide"    })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3,  bezier = "winOut",     style = "slide"    })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,  bezier = "wind",       style = "slide"    })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default"                        })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3,  bezier = "workswitch", style = "slidevert" })
hl.animation({ leaf = "borderangle",      enabled = true, speed = 30, bezier = "liner",      style = "loop"     })

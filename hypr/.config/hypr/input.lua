-- Input configuration
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "intl",
    },
})

-- Gesture configurations
hl.gesture({
    fingers   = 3,
    direction = "vertical",
    action    = "workspace",
})

hl.gesture({
    fingers   = 3,
    direction = "right",
    action    = function()
        hl.dispatch(hl.dsp.focus({ direction = "right" }))
    end,
})

hl.gesture({
    fingers   = 3,
    direction = "left",
    action    = function()
        hl.dispatch(hl.dsp.focus({ direction = "left" }))
    end,
})

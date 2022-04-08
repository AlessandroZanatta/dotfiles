local home = os.getenv "HOME"

local _M = {
    -- Default terminal
    terminal = "kitty",

    -- Default modkey.
    modkey = "Mod4",

    -- The alt key
    altkey = "Mod1",

    -- Default editor
    editor = os.getenv "EDITOR" or "nvim",
}

return _M

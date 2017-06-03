local layouts = {}

local awful = require("awful")
local lain = require("lain")

layouts.bundle = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    lain.layout.termfair,
    lain.layout.centerfair,
    lain.layout.cascade,
    lain.layout.cascadetile,
    lain.layout.centerwork,
    lain.layout.uselessfair,
    lain.layout.uselesspiral,
    lain.layout.uselesstile
}

return layouts

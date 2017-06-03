local themes = {}

local beautiful = require("beautiful") -- Theme handling library
local gears = require("gears") -- Theme handling library

local defs = require("defs") -- Theme handling library

local user_themes =
{
   "blue", "crown", "dk-grey",
   "dust", "lined", "matrix",
   "powerarrow-darker", "rbown",
   "smoked", "steamburn", "wombat",
   "zenburn-custom", "zenburn-red"
}
beautiful.init("/home/octocat/.config/awesome/themes/" .. user_themes[12] .. "/theme.lua")

theme.taglist_font = defs.taglist_font
theme.tasklist_font = defs.tasklist_font
theme.border_width = 2

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

return themes

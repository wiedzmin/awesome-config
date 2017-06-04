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

function themes:set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", themes.set_wallpaper)

return themes
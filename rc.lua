awful = require("awful")
local config_path = awful.util.getdir("config") -- config basedir
package.path = config_path .. "/?.lua;" .. package.path
package.path = config_path .. "/?/init.lua;" .. package.path
package.path = config_path .. "/lib/?.lua;" .. package.path
package.path = config_path .. "/lib/?/?.lua;" .. package.path
package.path = config_path .. "/lib/?/init.lua;" .. package.path


-- Standard awesome library
wibox = require("wibox") -- Widget and layout library
beautiful = require("beautiful") -- Theme handling library
vicious = require("vicious")
hints = require("hints")
lain = require("lain")
eminent = require("eminent")
cheeky = require("cheeky")

local gears = require("gears")
local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
-- local selection = require("selection")

awful.rules = require("awful.rules")
require("awful.autofocus")

-- include custom modules
local widgets = require("widgets")
local defs = require("defs")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

hints.init()

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

modkey = defs.modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "ω", "λ", "⧉", "∀" }, s, layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", defs.terminal .. " -e man awesome" },
   { "edit config", defs.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", defs.terminal },
                                    { "open browser", "firefox" },
                                    { "open Emacs", "emacs" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = defs.terminal -- Set the terminal for applications that require it
-- }}}


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    -- right_layout:add(mpdwidget)
    -- right_layout:add(separator)
    if s == 1 then
        right_layout:add(separator)
        right_layout:add(wibox.widget.systray())
    end
    right_layout:add(separator)
    right_layout:add(volume_widget)
    right_layout:add(separator)
    right_layout:add(memwidget)
    right_layout:add(separator)
    right_layout:add(cpuwidget)
    right_layout:add(separator)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(kbdwidget)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Custom functions
function simple_run_or_raise(klass, command)
   local matcher = function (c)
      return awful.rules.match(c, {class = klass})
   end
   awful.client.run_or_raise(command, matcher)
end

function show_apps_menu()
   -- If you want to always position the menu on the same place set coordinates
   awful.menu.menu_keys.down = { "Down", "Alt_L" }
   local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
end

apps = {
    ["f"]={'Firefox', 'firefox'},
    ["e"]={'Emacs', 'emacs'},
    ["t"]={'URxvt', 'urxvt'},
    ["z"]={'Zathura', 'zathura'},
    ["l"]={'Vlc', 'vlc'}
}

function run_or_raise_map()
   local grabber = keygrabber.run(function(mod, key, event)
           if event == "release" then return end
           keygrabber.stop(grabber)
           if apps[key] then
               simple_run_or_raise(apps[key][1], apps[key][2])
           end
   end)
end

webjumps = {
    ["m"]='https://mail.google.com/mail/u/0/#inbox',
    ["g"]='https://github.com/wiedzmin',
    ["y"]='http://yandex.ru',
    ["f"]='https://facebook.com/',
    ["t"]='http://www.multitran.ru/'
}

function webjumps_map()
   local grabber = keygrabber.run(function(mod, key, event)
           if event == "release" then return end
           keygrabber.stop(grabber)
           if key == 'o' then
               awful.util.spawn(defs.browser .. " " .. selection())
           else
               if webjumps[key] then
                   awful.util.spawn(defs.browser .. " " .. webjumps[key])
               end
           end
           simple_run_or_raise('Firefox', 'firefox')
   end)
end

websearches = {
    ["g"] = 'http://www.google.com/search?num=100&q=%s',
    ["y"] = 'http://yandex.ru/yandsearch?text=%s',
    ["t"] = 'http://www.multitran.ru/c/M.exe?CL=1&l1=1&s=%s'
}

function websearches_map()
   local grabber = keygrabber.run(function(mod, key, event)
           if event == "release" then return end
           keygrabber.stop(grabber)
           selection_ = selection()
           if websearches[key] and selection_ then
               awful.util.spawn(defs.browser .. " " .. string.format(websearches[key], selection_))
               simple_run_or_raise('Firefox', 'firefox')
           end
   end)
end
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "Left",   function () awful.client.focus.global_bydirection('left')    end),
    awful.key({ modkey,           }, "Right",  function () awful.client.focus.global_bydirection('right')    end),
    awful.key({ modkey,           }, "Up",     function () awful.client.focus.global_bydirection('up')    end),
    awful.key({ modkey,           }, "Down",   function () awful.client.focus.global_bydirection('down')    end),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Shift"   }, ",", function () awful.screen.focus(1) end),
    awful.key({ modkey, "Shift"   }, ".", function () awful.screen.focus(2) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(defs.terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    awful.key({ modkey, "Control" }, "z", function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey, "Control" }, "x", function () awful.util.spawn("mpc play") end),
    awful.key({ modkey, "Control" }, "c", function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey, "Control" }, "v", function () awful.util.spawn("mpc stop") end),
    awful.key({ modkey, "Control" }, "b", function () awful.util.spawn("mpc next") end),

    awful.key({ modkey }, "Escape", function() show_apps_menu() end),

    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -c 0 set Master 10+") end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -c 0 set Master 10-") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle >> /dev/null") end),

    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("i3lock -c 232729") end), -- TODO: fix "xset dpms force off"

    awful.key({ modkey, "Shift" }, "Right", function () awful.util.spawn("xrandr --output VGA1 --auto --right-of LVDS1") end),
    awful.key({ modkey, "Shift" }, "Left", function () awful.util.spawn("xrandr --output VGA1 --auto --left-of LVDS1") end),
    awful.key({ modkey, "Shift" }, "Up", function () awful.util.spawn("xrandr --output VGA1 --auto --above LVDS1") end),
    awful.key({ modkey, "Shift" }, "Down", function () awful.util.spawn("xrandr --output VGA1 --off") end),

    awful.key({ modkey }, "2", function () run_or_raise_map() end),
    awful.key({ modkey }, "w", function () webjumps_map() end),
    awful.key({ modkey }, "/", function () websearches_map() end),
    awful.key({ "Control" }, "\\", function () os.execute(defs.kbdd_dbus_prev_cmd) end),
    awful.key({ modkey }, "e", function () hints.focus() end),
    awful.key({ modkey, "Shift" }, "p", function () awful.util.spawn("gmrun") end),
    awful.key({ modkey, "Shift" }, "/", function() cheeky.util.switcher() end),
    awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end) -- TODO: take screenshot command from stumpwm
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, ",",      function (c) awful.client.movetoscreen(c,c.screen-1) end),
    awful.key({ modkey,           }, ".",      function (c) awful.client.movetoscreen(c,c.screen+1) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "F" .. i,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "F" .. i,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "F" .. i,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Emacs" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "URxvt" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "FBReader" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Zathura" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Vlc" },
      properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

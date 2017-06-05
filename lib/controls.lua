local controls = {}

local awful = require("awful")
local hints = require("hints")
local cheeky = require("cheeky")
local menubar = require("menubar")
local ezconfig = require("ezconfig")

local defs = require('defs')
local menus = require('menus')
local utils = require('utils')

controls.apps = {
    ["f"]={'Firefox', 'firefox'},
    ["а"]={'Firefox', 'firefox'},
    ["e"]={'Emacs', 'emacs'},
    ["у"]={'Emacs', 'emacs'},
    ["t"]={'URxvt', 'urxvt'},
    ["е"]={'URxvt', 'urxvt'},
    ["z"]={'Zathura', 'zathura'},
    ["я"]={'Zathura', 'zathura'},
    ["l"]={'Vlc', 'vlc'},
    ["д"]={'Vlc', 'vlc'},
    ["g"]={'Telegram', 'Telegram'},
    ["п"]={'Telegram', 'Telegram'},
    ["2"]={'Fbreader', 'fbreader'}
}

controls.webjumps = {
    ["m"]='https://mail.google.com/mail/u/0/#inbox',
    ["ь"]='https://mail.google.com/mail/u/0/#inbox',
    ["g"]='https://github.com/wiedzmin',
    ["п"]='https://github.com/wiedzmin',
    ["y"]='http://yandex.ru',
    ["н"]='http://yandex.ru',
    ["f"]='https://facebook.com/',
    ["а"]='https://facebook.com/',
    ["t"]='http://www.multitran.ru/',
    ["е"]='http://www.multitran.ru/'
}

controls.websearches = {
    ["g"] = 'http://www.google.com/search?num=100&q=%s',
    ["y"] = 'http://yandex.ru/yandsearch?text=%s',
    ["t"] = 'http://www.multitran.ru/c/M.exe?CL=1&l1=1&s=%s'
}

ezconfig.modkey = defs.modkey
ezconfig.altkey = defs.altkey

controls.globalkeys = ezconfig.keytable.join({
    ['M-<Escape>'] = awful.tag.history.restore,
    ['M-<Left>'] = function () awful.client.focus.global_bydirection('left') end,
    ['M-<Right>'] = function () awful.client.focus.global_bydirection('right') end,
    ['M-<Up>'] = function () awful.client.focus.global_bydirection('up') end,
    ['M-<Down>'] = function () awful.client.focus.global_bydirection('down') end,
    ['M-j'] = function () utils:focus_window_from_list(1) end,
    ['M-k'] = function () utils:focus_window_from_list(-1) end,
    ['M-S-j'] = function () awful.client.swap.byidx(  1) end,
    ['M-S-k'] = function () awful.client.swap.byidx( -1) end,
    ['M-C-j'] = function () awful.screen.focus_relative( 1) end,
    ['M-C-k'] = function () awful.screen.focus_relative(-1) end,
    ['M-S-,'] = function () awful.screen.focus(1) end,
    ['M-S-.'] = function () awful.screen.focus(2) end,
    ['M-u'] = awful.client.urgent.jumpto,
    ['M-<Tab>'] = utils.focus_window_previous,
    ['M-Return'] = function () awful.spawn(defs.terminal) end,
    ['M-C-r'] = awesome.restart,
    ['M-S-q'] = function() awesome.quit() end,
    ['M-l'] = function () awful.tag.incmwfact(0.05) end,
    ['M-h'] = function () awful.tag.incmwfact(-0.05) end,
    ['M-S-h'] = function () awful.tag.incnmaster(1) end,
    ['M-S-l'] = function () awful.tag.incnmaster(-1) end,
    ['M-C-h'] = function () awful.tag.incncol(1) end,
    ['M-C-l'] = function () awful.tag.incncol(-1) end,
    ['M-<Space>'] = function () awful.layout.inc(layouts, 1) end,
    ['M-S-<Space>'] = function () awful.layout.inc(layouts, -1) end,
    ['M-C-n'] = awful.client.restore,
    ['M-x'] = function()
       awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
       }
    end,
    ['M-p'] = function() menubar.show() end,
    ['M-C-z'] = function () awful.spawn("mpc prev") end,
    ['M-C-x'] = function () awful.spawn("mpc play") end,
    ['M-C-c'] = function () awful.spawn("mpc toggle") end,
    ['M-C-v'] = function () awful.spawn("mpc stop") end,
    ['M-C-b'] = function () awful.spawn("mpc next") end,
    ['M-<Escape>'] = function() menus.show_apps_menu() end,
    ['<XF86AudioRaiseVolume>'] = function () awful.spawn("amixer -c 0 set Master 10+") end,
    ['<XF86AudioLowerVolume>'] = function () awful.spawn("amixer -c 0 set Master 10-") end,
    ['<XF86AudioMute>'] = function () awful.spawn("amixer set Master toggle >> /dev/null") end,
    ['M-C-l'] = function () awful.spawn.with_shell("i3lock -c 232729 && sleep 1 && xset dpms force off") end,
    ['M-S-<Right>'] = function () awful.spawn("xrandr --output VGA1 --auto --right-of LVDS1") end,
    ['M-S-<Left>'] = function () awful.spawn("xrandr --output VGA1 --auto --left-of LVDS1") end,
    ['M-S-<Up>'] = function () awful.spawn("xrandr --output VGA1 --auto --above LVDS1") end,
    ['M-S-<Down>'] = function () awful.spawn("xrandr --output VGA1 --off") end,
    ['M-2'] = function () utils:run_or_raise_map(controls.apps) end,
    ['M-w'] = function () utils:webjumps_map(controls.webjumps, defs.browser) end,
    ['M-/'] = function () utils:websearches_map(controls.websearches, defs.browser) end,
    ['C-\\'] = utils.toggle_keyboard_layout,
    ['M-e'] = function () hints.focus() end,
    ['M-S-p'] = function () awful.spawn("gmrun") end,
    ['M-S-/'] = function() cheeky.util.switcher() end,
    ['<Print>'] = function () awful.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end -- TODO: take screenshot command from stumpwm
})

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    controls.globalkeys = awful.util.table.join(controls.globalkeys,
        -- View tag only.
        awful.key({ defs.modkey }, "F" .. i,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
        end),
        -- Toggle tag display.
        awful.key({ defs.modkey, "Control" }, "F" .. i,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
        end),
        -- Move client to tag.
        awful.key({ defs.modkey, "Shift" }, "F" .. i,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
        end),
        -- Toggle tag.
        awful.key({ defs.modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
    end))
end

-- Create a wibox for each screen and add it
controls.taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ defs.modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ defs.modkey }, 3,
        function(t)
            if client.focus then
                client.focus.toggle_tag(t)
            end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

controls.tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
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

controls.mouse_bindings = awful.util.table.join(
   awful.button({ }, 3, function () mymainmenu:toggle() end),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
)

controls.clientkeys = awful.util.table.join(
   awful.key({ defs.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ defs.modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ defs.modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ defs.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ defs.modkey,           }, ",",      function (c) c:move_to_screen(1) end),
   awful.key({ defs.modkey,           }, ".",      function (c) c:move_to_screen(2) end),
   awful.key({ defs.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ defs.modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ defs.modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

controls.clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ defs.modkey }, 1, awful.mouse.client.move),
   awful.button({ defs.modkey }, 3, awful.mouse.client.resize)
)

return controls

local keydefs = {}

local awful = require("awful")
local hints = require("hints")
local cheeky = require("cheeky")
local menubar = require("menubar")

local defs = require('defs')
local menus = require('menus')
local utils = require('utils')

keydefs.apps = {
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

keydefs.webjumps = {
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

keydefs.websearches = {
    ["g"] = 'http://www.google.com/search?num=100&q=%s',
    ["y"] = 'http://yandex.ru/yandsearch?text=%s',
    ["t"] = 'http://www.multitran.ru/c/M.exe?CL=1&l1=1&s=%s'
}

keydefs.global_keydefs = {
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
    ['M-C-l'] = function () awful.spawn("i3lock -c 232729") end, -- TODO: fix "xset dpms force off"
    ['M-S-<Right>'] = function () awful.spawn("xrandr --output VGA1 --auto --right-of LVDS1") end,
    ['M-S-<Left>'] = function () awful.spawn("xrandr --output VGA1 --auto --left-of LVDS1") end,
    ['M-S-<Up>'] = function () awful.spawn("xrandr --output VGA1 --auto --above LVDS1") end,
    ['M-S-<Down>'] = function () awful.spawn("xrandr --output VGA1 --off") end,
    ['M-2'] = function () utils:run_or_raise_map(keydefs.apps) end,
    ['M-w'] = function () utils:webjumps_map(keydefs.webjumps, defs.browser) end,
    ['M-/'] = function () utils:websearches_map(keydefs.websearches, defs.browser) end,
    ['C-\\'] = utils.toggle_keyboard_layout,
    ['M-e'] = function () hints.focus() end,
    ['M-S-p'] = function () awful.spawn("gmrun") end,
    ['M-S-/'] = function() cheeky.util.switcher() end,
    ['Print'] = function () awful.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end -- TODO: take screenshot command from stumpwm
}

return keydefs

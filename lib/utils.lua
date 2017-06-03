local utils = {}

local awful = require("awful")

local defs = require("defs")

function simple_run_or_raise(klass, command)
   local matcher = function (c)
      return awful.rules.match(c, {class = klass})
   end
   awful.client.run_or_raise(command, matcher)
end


function utils:run_or_raise_map(apps)
   local grabber = keygrabber.run(function(mod, key, event)
         if event == "release" then return end
         keygrabber.stop(grabber)
         if apps[key] then
            simple_run_or_raise(apps[key][1], apps[key][2])
         end
   end)
end

function utils:webjumps_map(webjumps, browser)
   local grabber = keygrabber.run(function(mod, key, event)
           if event == "release" then return end
           keygrabber.stop(grabber)
           if key == 'o' then
               awful.util.spawn(browser.command .. " " .. browser.params .. " " .. selection())
           else
               if webjumps[key] then
                   awful.util.spawn(browser.command .. " " .. browser.params .. " " .. webjumps[key])
               end
           end
           simple_run_or_raise(browser.class, browser.command)
   end)
end

function utils:websearches_map(searches, browser)
   local grabber = keygrabber.run(function(mod, key, event)
           if event == "release" then return end
           keygrabber.stop(grabber)
           selection_ = selection()
           if searches[key] and selection_ then
               awful.util.spawn(browser .. " " .. string.format(searches[key], selection_))
               simple_run_or_raise(browser.class, browser.command)
           end
   end)
end

do
    fake_input = root.fake_input
    function utils:toggle_keyboard_layout()
        -- for future Emacs windows handling, see example below
        -- root.fake_input fails for some reason
        -- local c = client.focus
        -- if c.class == "Emacs" or c.class == "emacs" then
        --     fake_input('key_press', 37);   fake_input('key_press', 51)
        --     fake_input("key_release", 37); fake_input('key_release', 51)
        --     fake_input('key_press', 37)
        --     return
        -- end
        os.execute(defs.kbdd_dbus_next_cmd)
    end
end

function utils:focus_window_from_list(dir) -- 1/-1
   awful.client.focus.byidx(dir)
   if client.focus then
      client.focus:raise()
   end
end

function utils:focus_window_previous()
   awful.client.focus.history.previous()
   if client.focus then
      client.focus:raise()
   end
end

return utils

local defs = {}

defs.modkey = "Mod4"

defs.kbdd_dbus_prev_cmd = "qdbus ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.prev_layout"

defs.taglist_font = "Consolas 14"

defs.terminal = "urxvt"
defs.editor = os.getenv("EDITOR") or "vim"
defs.editor_cmd = defs.terminal .. " -e " .. defs.editor
defs.browser = "firefox -new-tab"

return defs

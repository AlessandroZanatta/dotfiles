local awful = require "awful"

awful.spawn.single_instance("flameshot", awful.rules.rules)
awful.spawn.single_instance("/home/kalex/dotfiles/scripts/locker", awful.rules.rules)
awful.spawn.single_instance("picom", awful.rules.rules)
awful.spawn.single_instance("parcellite -n", awful.rules.rules)
awful.spawn.single_instance("nm-applet", awful.rules.rules)
awful.spawn.single_instance("autorandr -c", awful.rules.rules)
awful.spawn.single_instance("mailspring", awful.rules.rules)

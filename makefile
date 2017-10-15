all: copy_config

install:
	xargs -d '\n' -a arch_install.txt yaourt --noconfirm -S

change_shell:
	chsh -s /usr/bin/fish

copy_config: config_xres config_i3 config_compton config_polybar config_fish

config_xres:
	cp Xresources ~/.Xresources
	xrdb ~/.Xresources

config_i3: config_xres config_compton config_polybar copy_bg_feh
	cp -r i3 ~/.config/

config_compton:
	cp compton/config ~/.config/compton.conf

config_polybar:
	cp -r polybar ~/.config/
	chmod +x ~/.config/polybar/launch.sh

config_fish:
	fish -c "fisher install omf/theme-cmorrell.com"	

copy_bg_feh:
	cp -r feh ~/.config/
	
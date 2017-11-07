# Default to an HELP/Menu command
all: 
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

install_deps: t## Install dependencies program that the makefile use

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

ifndef VERBOSE
.SILENT:
endif
	
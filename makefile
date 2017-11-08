# Function for installing arch linux packages
define install
	xargs -d '\n' -a pkg/$1.txt yaourt --noconfirm -S
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Default to an HELP/Menu command
all: 
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

deps: ## Install dependencies program that the makefile use
	${call install,deps}

i3: deps icons_theme cursor_theme ## Install & configure i3wm
	echo "Nothing here :("

icons_theme: ## Install the icons theme
	${call install,icons_theme}

cursor_theme: ## Install the cursor theme
	${call install,cursor_theme}

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
	
# Function for installing arch linux packages
define install
	while read line; do yay -Q $$line >/dev/null || yay --noconfirm -S $$line; done < packages/$1.list
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Avoid that make thinks we are calling the sub directories
.PHONY: help deps i3 compton polybar kitty rofi fish icons_theme cursor_theme dev

# Default to an HELP/Menu command
help: ## Show this help
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

deps: ## Install dependencies program that the makefile use
	echo "Checking/Installing dependencies ..."
	${call install,deps}

i3: deps compton polybar termite rofi ## Install & configure i3wm + addons
	echo "Checking/Installing i3wm ..."
	${call install,i3}
	${call copy,i3}

compton: deps ## Install & configure compton
	echo "Checking/Installing compton ..."
	${call install,compton}
	${call copy,compton}

polybar: deps fonts ## Install & configure polybar
	echo "Checking/Installing polybar ..."
	${call copy,polybar}

kitty: deps fish fonts ## Install & configure termite
	echo "Checking/Installing kitty ..."
	${call install,kitty}
	${call copy,kitty}

rofi: deps fonts ## Install & config rofi
	echo "Checking/Installing rofi ..."
	${call install,rofi}
	${call copy,rofi}

fish: deps ## Install Fish shell + plugins
	${call install,fish}
	if [ "$$SHELL" != "/usr/bin/fish" ]; then chsh -s /usr/bin/fish; fi
	if [ ! -d "$$HOME/.local/share/omf/" ]; then curl -L https://get.oh-my.fish | fish; fi
	echo "omf install clearance" | fish
	echo "set -g theme_display_date no" | fish
	${call copy,fish}

icons_theme: ## Install the icons theme
	${call install,icons_theme}

cursor_theme: ## Install the cursor theme
	${call install,cursor_theme}

fonts: deps
	echo "Checking/Installing fonts ..."
	${call install,fonts}

dev: ## Install dev softwares
	${call install,dev}
	${call copy,vscode}

# Silent commands
.SILENT:

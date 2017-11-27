# Function for installing arch linux packages
define install
	while read line; do yaourt -Q $$line >/dev/null || yaourt --noconfirm -S $$line; done < packages/$1.list
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Avoid that make thinks we are calling the sub directories
.PHONY: help deps i3 compton polybar termite rofi zsh gtk_config icons_theme cursor_theme dev

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

polybar: deps ## Install & configure polybar
	echo "Checking/Installing polybar ..."
	${call copy,polybar}

termite: deps zsh gtk_config ## Install & configure termite
	echo "Checking/Installing termite ..."
	${call install,termite}
	${call copy,termite}

rofi: deps ## Install & config rofi
	echo "Checking/Installing rofi ..."
	${call install,rofi}
	${call copy,rofi}

zsh: deps ## Install zsh + plugins & configure them
	echo "Checking/Installing zsh ..."
	${call install,zsh}
	${call copy,zsh}
	if [ "$$SHELL" != "/usr/bin/zsh" ]; then chsh -s /usr/bin/zsh; fi

gtk_config: deps
	echo "Checking/Installing gtk config ..."
	${call copy,gtk}

icons_theme: ## Install the icons theme
	${call install,icons_theme}

cursor_theme: ## Install the cursor theme
	${call install,cursor_theme}

dev: ## Install dev softwares
	${call install,dev}

# Silent commands
.SILENT:
	
# Function for installing arch linux packages
define install
	xargs -d '\n' -a packages/$1.list yaourt --noconfirm --needed -S
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Avoid that make thinks we are calling the sub directories
.PHONY: help deps i3 compton polybar termite zsh gtk icons_theme cursor_theme dev

# Default to an HELP/Menu command
help: ## Show this help
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

deps: ## Install dependencies program that the makefile use
	${call install,deps}

i3: deps compton polybar termite ## Install & configure i3wm + addons
	${call install,i3}
	${call copy,i3}

compton: deps ## Install & configure compton
	${call install,compton}
	${call copy,compton}

polybar: deps ## Install & configure polybar
	${call copy,polybar}

termite: deps zsh ## Install & configure termite
	${call install,termite}
	${call copy,termite}

zsh: deps ## Install zsh + plugins & configure them
	${call install,zsh}
	${call copy,zsh}
	chsh -s /usr/bin/zsh

gtk: deps
	${call copy,gtk}

icons_theme: ## Install the icons theme
	${call install,icons_theme}

cursor_theme: ## Install the cursor theme
	${call install,cursor_theme}

dev: ## Install dev softwares
	${call install,dev}

# Silent commands
.SILENT:
	
# Function for installing arch linux packages
define install
	xargs -d '\n' -a pkg/$1.txt yaourt --noconfirm --needed -S
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Default to an HELP/Menu command
all: 
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: deps i3 icons_theme cursor_theme zsh

deps: ## Install dependencies program that the makefile use
	${call install,deps}

i3: deps icons_theme cursor_theme ## Install & configure i3wm
	${call install,i3}
	${call copy,xres}
	xrdb ~/.Xresources
	${call copy,i3}
	${call copy,compton}
	${call copy,polybar}
	chmod +x ~/.config/polybar/launch.sh
	${call copy,feh}

icons_theme: ## Install the icons theme
	${call install,icons_theme}

cursor_theme: ## Install the cursor theme
	${call install,cursor_theme}

zsh: ## Install zsh + plugins & configure them
	${call install,zsh}
	${call copy,zsh}
	chsh -s /usr/bin/zsh

# Silent commands
.SILENT:
	
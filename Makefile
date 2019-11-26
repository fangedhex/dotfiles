# Function for installing arch linux packages
define install
	while read line; do yay -Q $$line >/dev/null || yay --noconfirm -S $$line; done < packages/$1.list
endef

# Function to "copy" (symlink) to the $HOME directory
define copy
	stow -t ~ $1
endef

# Avoid that make thinks we are calling the sub directories
.PHONY: help deps i3 compton polybar kitty rofi fish icons_theme cursor_theme dev zsh

# Default to an HELP/Menu command
help: ## Show this help
	echo "--- Makefile Menu ---"
	echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

deps: ## Install dependencies program that the makefile use
	echo "Checking/Installing dependencies ..."
	${call install,deps}

i3: deps compton polybar kitty rofi ## Install & configure i3wm + addons
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

zsh: deps ## Install Zsh shell + config
	${call install,zsh}
	echo "Switching shell for current user"
	if [ "$$SHELL" != "/usr/bin/zsh" ]; then chsh -s /usr/bin/zsh; fi
	echo "Downloading Oh My Zsh install script"
	curl -fsSLO https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	sh install.sh --unattended
	echo "Installing required plugins for Oh My Zsh"
	git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zpm-zsh/title ~/.oh-my-zsh/custom/plugins/title
	curl -L -o ~/.oh-my-zsh/custom/themes/materialshell.zsh-theme https://raw.githubusercontent.com/carloscuesta/materialshell/master/materialshell.zsh
	${call copy,zsh}

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

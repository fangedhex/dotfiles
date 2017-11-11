source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Theme config
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="  ↳ "
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_COLOR_SCHEME='light'
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell (opensuse).

# Sourcing other stuff
# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# ALIASES
test -s ~/.alias && . ~/.alias || true

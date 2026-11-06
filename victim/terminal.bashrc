if [ -f /etc/bash.bashrc ]; then . /etc/bash.bashrc; fi
export SYSTEMD_PAGER=cat
export SYSTEMD_COLORS=1
PS1='\u@\h:\w\$ '
PROMPT_COMMAND='printf "\033]0;ubuntu@victim\007"'

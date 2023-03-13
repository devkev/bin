# bashrc

PROMPT_COMMAND='_preserve_lastarg="$_"'"$'\n'$PROMPT_COMMAND"
bind -x '"\xC0\1":: "$_preserve_lastarg"'
bind '"\xC0\2": accept-line'
bind '"\r": "\xC0\1\xC0\2"'

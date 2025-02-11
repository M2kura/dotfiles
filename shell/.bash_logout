# ~/.bash_logout: executed by bash(1) when login shell exits.

# Clear console history for privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# Clear terminal scrollback buffer
clear

# Clean temporary files
rm -f ~/.bash_history-*.tmp 2>/dev/null

# Optionally, clear clipboard
if command -v xsel >/dev/null 2>&1; then
    xsel -c
fi

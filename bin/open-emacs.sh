#!/bin/sh
# Connect to the requested server, starting its matching configuration if needed.
set -eu

case "${1:-}" in
    jose)
        profile=jose
        init_directory="$HOME/.config/jose-emacs"
        ;;
    doom)
        profile=doom
        init_directory="$HOME/.config/emacs"
        DOOMDIR="$HOME/.config/doom"
        export DOOMDIR
        ;;
    *)
        echo "Usage: $0 jose|doom" >&2
        exit 2
        ;;
esac

# Karabiner does not inherit the interactive shell's Homebrew environment.
PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH

if /opt/homebrew/bin/emacsclient -n -c -s "$profile" -a /usr/bin/false; then
    exit 0
fi

/opt/homebrew/bin/emacs --init-directory="$init_directory" --daemon="$profile"
exec /opt/homebrew/bin/emacsclient -n -c -s "$profile" -a /usr/bin/false

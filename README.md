This is a simple kopipe/SJIS art manager for bash. It stores your pasta in text files in a folder somewhere (by default either the value of `$KOPIPEDIR` or `~/.kopipe` if that isn't set), and provides a convenient interface for viewing and editing them. It's only marginally less convenient than just using the shell itself. `./kopipe.sh --help` for information on how to use it.

Also provided is a `bash_completion` script for it; put it in `/etc/bash_completion.d/` or source it somewhere likely to get called before you'll want auto-completion.

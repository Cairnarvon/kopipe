#!/bin/bash

if [ -z "$KOPIPEDIR" ]; then
    KOPIPEDIR=~/.kopipe
fi


# If it doesn't exist already, make a new kopipe directory

if [ ! -d "$KOPIPEDIR" ]; then
    mkdir "$KOPIPEDIR" && \
    echo -e "New kopipe directory created at \033[1m$KOPIPEDIR\033[0m" >&2 || \
    echo -e "\033[1;31mERROR\033[0m Couldn't create kopipe directory at"\
            "\033[1m$KOPIPEDIR\033[0m" >&2
fi



# Functions

# -h, --help, or no arguments: display help and exit

usage()
{
    echo -e "\033[1mNAME\033[0m\n"                                          \
            "\tkopipe - \033[1mXarn\033[0m's kopipe manager.\n"             \
            "\n\033[1mUSAGE\033[0m\n"                                       \
            "\t$0 \033[4mNAME\033[0m...\n"                                  \
            "\t\tDisplay the named kopipe.\n\n"                             \
            "\t$0 [\033[1m-h\033[0m|\033[1m--help\033[0m]\n"                \
            "\t\tShow this message and exit.\n\n"                           \
            "\t$0 \033[1m-l\033[0m|\033[1m--list\033[0m"                    \
            "['\033[4mGLOB\033[0m']\n"                                      \
            "\t\tList the available kopipe.\n\n"                            \
            "\t$0 \033[1m-n\033[0m|\033[1m--new\033[0m"                     \
            "\033[4mNAME\033[0m\n"                                          \
            "\t\tRead new kopipe from stdin and save it under"              \
            "\033[4mNAME\033[0m.\n\n"                                       \
            "\t$0 \033[1m-e\033[0m|\033[1m--edit\033[0m"                    \
            "\033[4mNAME\033[0m...\n"                                       \
            "\t\tOpen kopipe \033[4mNAME\033[0m in your favourite editor"   \
            "(\$EDITOR environment\n\t\tvariable or \033[1mvi\033[0m).\n\n" \
            "\t$0 \033[1m-d\033[0m|\033[1m--delete\033[0m"                  \
            "\033[4mNAME\033[0m...\n"                                       \
            "\t\tDelete kopipe \033[4mNAME\033[0m.\n\n"                     \
            "\t$0 \033[1m-s\033[0m|\033[1m--search\033[0m"                  \
            "\033[4mPATTERN\033[0m ['\033[4mGLOB\033[0m']\n"                \
            "\t\tFind kopipe matching \033[4mPATTERN\033[0m,"               \
            "possibly just in \033[4mGLOB\033[0m.\n" >&2
    exit 1
}


# -l, --list: show current kopipe collection

list()
{
    ls $* 2>/dev/null || echo -e "\033[2m(Nothing here.)\033[0m" >&2

    exit 0
}


# -n, --new: create new kopipe from stdin

new()
{
    # Clear file if it exists already
    echo -n > "$1"

    while read -r line; do
        echo $line >> "$1"
    done

    echo -e "\033[1m$1\033[0m saved." >&2

    exit 0
}


# -e, --edit: edit kopipe in editor

edit()
{
    if [ -z "$EDITOR" ]; then
        EDITOR=vi
    fi

    $EDITOR $*

    exit 0
}


# -d, --del, --delete: delete existing kopipe

delete()
{
    rm -i -- $*
    exit 0
}


# -s, --search: search existing kopipe

search()
{
    local PATTERN

    PATTERN="$1"
    shift

    grep -l "$PATTERN" $* || echo -e "\033[2mNo match.\033[0m" >&2

    exit 0
}


# No options: just display kopipe

display()
{
    if [ -f "$1" ]; then
        echo -e "\033[2m$1\033[0m" >&2
        cat "$1"
        echo >&2
    else
        echo -e "\033[2mKopipe \033[1m$1\033[2m does not seem to exist.\033[0m" >&2
    fi

    shift
    if [ ! -z "$1" ]; then
        display $*
    fi

    exit 0
}


# Process arguments

arg=$1
shift

cd "$KOPIPEDIR"

# If there's a second argument, we're probably doing something

if [ ! -z "$1" ]; then
    case $arg in
        -n|--new)
            new $*
            ;;
        -e|--edit)
            edit $*
            ;;
        -d|--del|--delete)
            delete $*
            ;;
        -s|--search)
            search $*
            ;;
    esac
fi


# Maybe there's only one argument

case $arg in
    -n|--new|-e|--edit|-d|--del|--delete|-s|--search)
        echo "That command needs an argument, comrade." >&2
        exit 2
        ;;
    -h|--help)
        usage
        ;;
    -l|--list)
        list $*
        ;;
esac


# However many arguments there are, they don't add up to a valid command, so
# they must be a request for kopipe

if [ ! -z "$arg" ]; then
    display "$arg" $*
fi


# If there aren't any arguments at all, let's remind the user what's possible

usage

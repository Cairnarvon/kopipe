# bash auto-completion for kopipe
# Put this file (or a link to it) in /etc/bash_completion.d/

__kopipe()
{
    local cur

    COMPREPLY=()
    cur=`_get_cword`

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W \
            '-h --help -l --list -n --new -e --edit -d --delete -s --search' \
            -- $cur ) )
    else
        cd ~/.kopipe
        COMPREPLY=( $( compgen -f -- $cur ) )
        cd - >/dev/null
    fi
}
complete -F __kopipe $filenames kopipe
complete -F __kopipe $filenames kopipe.sh

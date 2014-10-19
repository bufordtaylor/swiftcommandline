# Attributing Huy, who had the original idea with bashmarks. This file has been edited for improvements,
# bug fixes, and adding more features.

# Copyright (c) 2010, Huy Nguyen, http://www.huyng.com
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided
# that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice, this list of conditions
#       and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
#       following disclaimer in the documentation and/or other materials provided with the distribution.
#     * Neither the name of Huy Nguyen nor the names of contributors
#       may be used to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# USAGE:
# s referencename file - saves the file as referencename
# s referencename - saves the curr dir as referencename
# o referencename - open file in default program
# e referencename - edit the file in vim
# g referencename - jumps to the that reference
# g b[TAB] - tab completion is available
# p referencename - prints the reference
# p b[TAB] - tab completion is available
# d referencename - deletes the reference
# d [TAB] - tab completion is available
# l - list all references

# setup file to store references
if [ ! -n "$SWIFTCOMMANDLINE" ]; then
    SWIFTCOMMANDLINE=~/.swiftcommandline
fi
touch $SWIFTCOMMANDLINE

# save current directory to references
function s {
    check_help $1 && return 0
    _reference_name_valid "$@" || return 1

    if [ -z "$2" ]; then
        local dir=$(echo $PWD | sed "s#^$HOME#\$HOME#g")
    elif [[ "${2:0:1}" == "/" ]]; then
        local dir="$2"
    else
        local dir="$PWD/$2"
    fi

    echo "export VSF_$1=\"$dir\"" >> $SWIFTCOMMANDLINE
}

# jump to reference
function g {
    check_help $1 && return 0
    source $SWIFTCOMMANDLINE
    cd "$(eval $(echo echo $(echo \$VSF_$1)))"
}

# edit reference
function e {
    check_help $1 && return 0
    source $SWIFTCOMMANDLINE
    vim "$(eval $(echo echo $(echo \$VSF_$1)))"
}

# edit reference
function o {
    check_help $1 && return 0
    source $SWIFTCOMMANDLINE
    open "$(eval $(echo echo $(echo \$VSF_$1)))"
}

# print reference
function p {
    check_help $1 && return 0
    source $SWIFTCOMMANDLINE
    echo "$(eval $(echo echo $(echo \$VSF_$1)))"
}

# delete reference
function d {
    check_help $1 && return 0
    _reference_name_valid "$@" || return 1

    _purge_line "$SWIFTCOMMANDLINE" "export VSF_$1="
    unset "VSF_$1"
}

# print out help for the forgetful
function check_help {
    if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] ; then
        echo ''
        echo 's <reference_name> <file> - Saves the path to the file  as "reference_name"'
        echo 's <reference_name> - Saves the path as "reference_name"'
        echo 'g <reference_name> - Jump to the path specified'
        echo 'e <reference_name> - Open reference file in vim'
        echo 'o <reference_name> - Open reference file in default program'
        echo 'p <reference_name> - Prints the file associated with "reference_name"'
        echo 'd <reference_name> - Deletes the reference'
        echo 'l                 - Lists all available references'
        return 0
    fi

    return 1
}

# list references with dirnam
function l {
    check_help $1 && return 0
    source $SWIFTCOMMANDLINE

    # if color output is not working for you, comment out the line below '\033[1;32m' == "red"
    env | sort | awk '/VSF_.+/{split(substr($0,5),parts,"="); printf("\033[1;31m%-20s\033[0m %s\n", parts[1], parts[2]);}'

    # uncomment this line if color output is not working with the line above
    # env | grep "^VSF_" | cut -c5- | sort |grep "^.*="
}

# list references without name
function _sl {
    source $SWIFTCOMMANDLINE
    env | grep "^VSF_" | cut -c5- | sort | grep "^.*=" | cut -f1 -d "="
}

# validate reference name
function _reference_name_valid {
    exit_message=""

    if [ -z $1 ]; then
        exit_message="reference name required"
        echo "$exit_message"
        return 1
    elif [ "$1" != "$(echo $1 | sed 's/[^A-Za-z0-9_]//g')" ]; then
        exit_message="reference name is not valid, because it is not match [A-Za-z0-9_]* regexp"
        echo "$exit_message"
        return 1
    fi

    return 0
}

# completion command
function _scomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_sl`' -- $curw))
    return 0
}

# ZSH completion command
function _scompzsh {
    reply=($(_sl))
}

# safe delete line from sdirs
function _purge_line {
    if [ -s "$1" ]; then
        # safely create a temp file
        t=$(mktemp -t swiftcommandline.XXXXXX) || exit 1
        trap "rm -f -- '$t'" EXIT

        # purge line
        sed "/$2/d" "$1" > "$t"
        mv "$t" "$1"

        # cleanup temp file
        rm -f -- "$t"
        trap - EXIT
    fi
}

# bind completion command for e,p,d,g to _scomp
if [ $ZSH_VERSION ]; then
    compctl -K _scompzsh e
    compctl -K _scompzsh o
    compctl -K _scompzsh g
    compctl -K _scompzsh p
    compctl -K _scompzsh d
else
    shopt -s progcomp
    complete -F _scomp e
    complete -F _scomp o
    complete -F _scomp g
    complete -F _scomp p
    complete -F _scomp d
fi

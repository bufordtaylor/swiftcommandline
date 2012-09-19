### Swiftcommandline is a quick way to edit, go to, or open commonly referenced files or folders

## Install

[github - swiftcommandline](https://www.github.com/bufordtaylor/swiftcommandline)

1. git clone git://github.com/bufordtaylor/swiftcommandline.git
2. make install
3. source **~/.local/bin/swiftcommandline.sh** from within your **~.bash\_profile** or **~/.bashrc** file

## Shell Commands

    s <reference_name> <file> - Saves the path to the file as "reference_name"
    s <reference_name> - Saves the path as "reference_name"
    g <reference_name> - Jump to referenced path
    e <reference_name> - Open reference file in vim
    o <reference_name> - Open reference file in default program
    p <reference_name> - Prints the file associated with "reference_name"
    d <reference_name> - Deletes the reference
    l                  - Lists all available references

## Example 1

    $ s notes ~/Code/notes.txt
    $ cd ~ (or anywhere)
    $ e n<TAB COMPLETE>
    or
    $ e notes
    Now we are editing notes.txt in vim

## Example 2

    $ cd /Volumes/Terra/Dropbox/todo/
    $ s todo
    $ cd ~/some/other/dir
    $ g t<TAB COMPLETE>
    or
    $ g todo
    Now we are in /Volumes/Terra/Dropbox/todo/

## Example 3

    $ s prettypicture ~/Art/pretty_picture.psd
    $ o p<TAB COMPLETE>
    or
    $ o prettypicture
    Now we have opened pretty_picture.psd in Photoshop

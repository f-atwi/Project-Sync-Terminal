#!/usr/bin/env bash

# variables
required_width=80
required_height=34

# variable player contains the x and y position of the player initially at (0,0)
player_pos=(16 78)

check_terminal_size() {
    # Using tput to get terminal dimensions
    lines=$(tput lines)
    columns=$(tput cols)

    # Check if terminal is large enough. If not, exit with error 1
    if (($lines < $required_height || $columns < $required_width)); then
        echo -e "The terminal must have a dimension of at least $required_width"x"$required_height\nThe current size is $columns"x"$lines" 1>&2
        exit 1
    fi
}

build_world() {
    # Clear the terminal without deleting the scrollback buffer
    clear -x

    # Calculating the vertical and vertical seperator size to center the world
    v_separator_count=$((($lines - 34) / 2))
    h_separator_count=$((($columns - 80) / 2))

    v_separator=''
    h_separator=''
    # Creation of the vertical and horizontal seperators
    for ((i = 0; i < $v_separator_count; i++)); do
        v_separator+='\n'
    done
    for ((i = 0; i < $h_separator_count; i++)); do
        h_separator+=' '
    done
    # Print the world
    world="\
$v_separator\
${h_separator}╔══════════════════════════════════════════════════════════════════════════════╗
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}╠═════════    ══════════    ══════════    ══════════    ══════════    ═════════╣
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║     ╔══════════╗                ╔══════════╗                ╔══════════╗     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ╚══════════╝                ╚══════════╝                ╚══════════╝     ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║     ╔══════════╗                ╔══════════╗                ╔══════════╗     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ║          ║                ║          ║                ║          ║     ║
${h_separator}║     ╚══════════╝                ╚══════════╝                ╚══════════╝     ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}╠═════════    ══════════    ══════════    ══════════    ══════════    ═════════╣
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}║                                                                              ║
${h_separator}╚══════════════════════════════════════════════════════════════════════════════╝"

    echo -en "$world"
}

change_world_block() {
    # echo $v_separator_count $h_separator_count
    tput cup $(($1+$v_separator_count+1)) $(($2+$h_separator_count+1))
    echo -en "$3"
}

# Call the functions
check_terminal_size
build_world
change_world_block ${player_pos[0]} ${player_pos[1]} '^'

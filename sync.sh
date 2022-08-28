#!/usr/bin/env bash

# variables
required_width=80
required_height=35

check_terminal_size() {
    # Using tput to get terminal dimensions
    lines=$(tput lines)
    columns=$(tput cols)
    # Check if terminal is large enough. If not, exit with error 1
    if (($lines < $required_height || $columns < $required_width)); then
        echo -e "The terminal must have a dimension of at least $required_width"x"$required_height\nThe current size is $lines $columns" 1>&2
        exit 1
    fi
}

build_world() {
    # Clear the terminal without deleting the scrollback buffer
    clear -x

    # Calculating the vertical and vertical seperator size to center the world
    local v_separator_count=$((($lines - 34) / 2))
    local h_separator_count=$((($columns - 80) / 2))

    # Creation of the vertical and horizontal seperators
    for ((i = 0; i < $v_separator_count; i++)); do
        v_separator+='\n'
    done
    for ((i = 0; i < $h_separator_count; i++)); do
        h_separator+=' '
    done

    # Print the world
    echo -n -e $v_separator
    echo -e "${h_separator}╔══════════════════════════════════════════════════════════════════════════════╗"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}╠═════════    ══════════    ══════════    ══════════    ══════════    ═════════╣"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║     ╔══════════╗                ╔══════════╗                ╔══════════╗     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ╚══════════╝                ╚══════════╝                ╚══════════╝     ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║     ╔══════════╗                ╔══════════╗                ╔══════════╗     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ║          ║                ║          ║                ║          ║     ║"
    echo -e "${h_separator}║     ╚══════════╝                ╚══════════╝                ╚══════════╝     ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}╠═════════    ══════════    ══════════    ══════════    ══════════    ═════════╣"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}║                                                                              ║"
    echo -e "${h_separator}╚══════════════════════════════════════════════════════════════════════════════╝\n"
}

# Call the functions
check_terminal_size
build_world

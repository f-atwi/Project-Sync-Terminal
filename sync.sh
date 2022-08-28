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

check_terminal_size
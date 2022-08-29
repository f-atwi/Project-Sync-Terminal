#!/usr/bin/env bash

# variables
required_width=80
required_height=34
size_ok=1

# variable player contains the x and y position of the player initially at (0,0)
player_pos=(16 78)
declare -a map=()
# Below is the variable map which represents the map of the game. Modify the below array to change the map.
# Empty spaces are represented by ' ' and walls are represented by 'W'.
# The outer walls of the map are not represented.
# The size of the map is 78x32
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("WWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWW")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("     WWWWWWWWWWWW                WWWWWWWWWWWW                WWWWWWWWWWWW     ")
map+=("     W          W                W          W                W          W     ")
map+=("     W          W                W          W                W          W     ")
map+=("     W          W                W          W                W          W     ")
map+=("     WWWWWWWWWWWW                WWWWWWWWWWWW                WWWWWWWWWWWW     ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("     WWWWWWWWWWWW                WWWWWWWWWWWW                WWWWWWWWWWWW     ")
map+=("     W          W                W          W                W          W     ")
map+=("     W          W                W          W                W          W     ")
map+=("     W          W                W          W                W          W     ")
map+=("     WWWWWWWWWWWW                WWWWWWWWWWWW                WWWWWWWWWWWW     ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("WWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWWW    WWWWWWWWW")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")
map+=("                                                                              ")

world_template="\
V\
H╔══════════════════════════════════════════════════════════════════════════════╗\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H║m║\\n\
H╚══════════════════════════════════════════════════════════════════════════════╝"

check_terminal_size() {
    # Using tput to get terminal dimensions
    lines=$(tput lines)
    columns=$(tput cols)

    # Check if terminal is large enough. If not, exit with error 1
    if (($lines < $required_height || $columns < $required_width)); then
        clear
        echo -e "The terminal must have a dimension of at least $required_width"x"$required_height\nThe current size is $columns"x"$lines" 1>&2
        size_ok=0
        return
    fi
    size_ok=1
    # Calculating the vertical and vertical seperator size to center the world
    v_separator_count=$((($lines - 34) / 2))
    h_separator_count=$((($columns - 80) / 2))

    # Creation of the vertical and horizontal seperators
    v_separator=''
    h_separator=''
    for ((i = 0; i < $v_separator_count; i++)); do
        v_separator+='\n'
    done
    for ((i = 0; i < $h_separator_count; i++)); do
        h_separator+=' '
    done
}

update_world() {
    local world_temp=$world_template
    for row in "${map[@]}"; do
        world_temp=$(echo -en "$world_temp" | sed "0,/m/{s/m/$row/}")
    done
    world=$(echo -en "$world_temp" | sed "s/H/$h_separator/g" | sed "s/V/$v_separator/g")
}

print_world() {
    if [[ size_ok -eq 0 ]]; then
        return
    fi
    # Clear the terminal
    clear
    update_world
    # Print the world
    echo -en "$world"
}

place_object() {
    object_row=${map[$1]}
    object_at_pos=${object_row:$2:1}
    # Check if object_at_pos is a single space
    if [[ $object_at_pos == ' ' ]]; then
        object_row=${object_row:0:$2}$3${object_row:$2+1}
        map[$1]="$object_row"
    else
        echo -e "The position is already occupied" 1>&2
    fi
    update_world
}

main() {
    trap "check_terminal_size;print_world" SIGWINCH
    # Call the functions
    check_terminal_size
    update_world
    place_object 0 0 ^
    print_world

    while :; do
        sleep .1
    done
}

main

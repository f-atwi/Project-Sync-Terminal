#!/usr/bin/env bash

# variables
REQUIRED_WIDTH=80
REQUIRED_HEIGHT=34
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
    if (($lines < $REQUIRED_HEIGHT || $columns < $REQUIRED_WIDTH)); then
        clear
        echo -e "The terminal must have a dimension of at least $REQUIRED_WIDTH"x"$REQUIRED_HEIGHT\nThe current size is $columns"x"$lines" 1>&2
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

get_row() {
    local _arr="$1"
    local -n _arr_ref="$1"
    local x=$2
    # Get the row at the given position
    local row="${_arr_ref[$x]}"
    echo -e "$row"
}

get_element_from_row() {
    local row="$1"
    local y=$2
    # Get the element at the given position
    local element="${row:$y:1}"
    echo -en "$element"
}

get_element_at_position() {
    # Get the object at the given position
    local _arr="$1"
    local -n _arr_ref="$1"
    local x=$2
    local y=$3
    local row="$(get_row $_arr $x)"
    local element="$(get_element_from_row "$row" $y)"
    echo -en "$element"
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

replace_element_at_position() {
    # Substitute the element at the given position
    local _arr="$1"
    local -n _arr_ref="$1"
    local x=$2
    local y=$3
    local new_element=$4
    local row="$(get_row $_arr $x)"
    local element=$(get_element_from_row $row $y)
    local new_row=${row:0:$3}$new_element${row:$3+1}
    _arr_ref[$x]=$new_row
    update_world
}

replace_element_at_position_if_possible() {
    local _arr="$1"
    local -n _arr_ref="$1"
    local x=$2
    local y=$3
    local element_new=$4
    local row="$(get_row $_arr $x)"
    local element="$(get_element_from_row "$row" $y)"
    # Check if element_at_pos is a single space
    if [[ $element == ' ' ]]; then
        replace_element_at_position $_arr $x $y $element_new
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
    # place_object 2 0 ^
    # get_row map 5
    replace_element_at_position_if_possible map 4 0 ^


    while :; do
        sleep .1
    done
}

main

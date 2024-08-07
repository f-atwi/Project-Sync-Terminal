#!/usr/bin/env bash

# variables
REQUIRED_WIDTH=80
REQUIRED_HEIGHT=34
size_ok=1

# variable player contains the x and y position of the player initially at (0,0)
player_pos=(16 78)

# map.txt contains the layout of the map. Modify it to change the map.
# Empty spaces are represented by ' ' and walls are represented by 'W'.
# The size of the default map is 80x34
declare -a map=()
readarray -t map < map.txt

declare -A walls
walls=(
    [ud]="║" [u]="║" [d]="║" [lr]="═" [l]="═" [r]="═"
    [ur]="╚" [ul]="╝" [dr]="╔" [dl]="╗"
    [udlr]="╬" [ulr]="╩" [dlr]="╦" [udr]="╠" [udl]="╣"
    [none]="█"
)


build_walls() {
    local -a built_map=()
    # "${#map[@]}}" returns the number of rows in the map

    for ((row = 0; row < "${#map[@]}"; row++)); do
        built_row=""
        for ((col = 0; col < "${#map[$row]}"; col++)); do
            local element="${map[$row]:$col:1}"

            if [[ "$element" != "W" ]]; then
                built_row+="$element"
                continue
            fi

            local wall=""

            if ((row > 0)); then
                local up="${map[$((row - 1))]:$col:1}"
                if [[ "$up" == "W" ]]; then
                    wall+='u'
                fi
            fi

            if ((row < "${#map[@]}" - 1)); then
                local down="${map[$((row + 1))]:$col:1}"
                if [[ "$down" == "W" ]]; then
                    wall+='d'
                fi
            fi

            if ((col > 0)); then
                local left="${map[$row]:$((col - 1)):1}"
                if [[ "$left" == "W" ]]; then
                    wall+='l'
                fi
            fi

            if ((col < "${#map[$row]}" - 1)); then
                local right="${map[$row]:$((col + 1)):1}"
                if [[ "$right" == "W" ]]; then
                    wall+='r'
                fi
            fi

            if [[ -z "$wall" ]]; then
                wall="none"
            fi

            built_row+="${walls[$wall]}"
        done
        built_map+=("$built_row")
    done
    map=("${built_map[@]}")
}

check_terminal_size() {
    # Using tput to get terminal dimensions
    local lines=$(tput lines)
    local columns=$(tput cols)

    # Check if terminal is large enough. If not, exit with error 1
    if ((lines < REQUIRED_HEIGHT || columns < REQUIRED_WIDTH)); then
        clear
        echo "The terminal must have a dimension of at least $REQUIRED_WIDTH"x"$REQUIRED_HEIGHT" 1>&2
        echo "The current size is $columns"x"$lines" 1>&2
        size_ok=0
        return
    fi
    size_ok=1
    # Calculating the vertical and vertical seperator size to center the world
    local v_separator_count=$(((lines - REQUIRED_HEIGHT) / 2))
    local h_separator_count=$(((columns - REQUIRED_WIDTH) / 2))

    # Creation of the vertical and horizontal seperators
    v_separator=$(printf '\n%.0s' $(seq 1 $v_separator_count))
    h_separator=$(printf ' %.0s' $(seq 1 $h_separator_count))
}

get_row() {
    local _arr="$1"
    local x=$2
    # Get the row at the given position
    local row="${_arr[$x]}"
    echo "$row"
}

get_element_from_row() {
    local row="$1"
    local y=$2
    # Get the element at the given position
    local element="${row:$y:1}"
    echo "$element"
}

get_element_at_position() {
    # expects an array as first argument, x and y coordinates as second and third argument
    # Get the object at the given position
    local _arr="$1"
    local -n _arr_ref="$1"
    local x=$2
    local y=$3
    local row="$(get_row $_arr $x)"
    local element="$(get_element_from_row "$row" $y)"
}

update_world() {
    local _arr="$1"
    local -n _arr_ref="$1"
    local world_template="\
V\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm\\n\
Hm"
    local world_temp=$world_template
    for row in "${_arr_ref[@]}"; do
        world_temp=$(echo -en "$world_temp" | sed "0,/m/{s/m/$row/}")
    done
    world=$(echo -en "$world_temp" | sed "s/H/$h_separator/g" | sed "s/V/$v_separator/g")
}

print_world() {
    local _arr="$1"
    local -n _arr_ref="$1"
    if [[ size_ok -eq 0 ]]; then
        return
    fi
    # Clear the terminal
    clear
    update_world "$_arr"
    # Print the world
    echo -en "$world"
}

replace_element_at_position() {
    # Substitute the element at the given position
    local -a _arr=("${!1}")  # Make a copy of the array passed as argument
    local x=$2
    local y=$3
    local new_element=$4
    local row="${_arr[$x]}"
    local new_row="${row:0:$y}$new_element${row:$y+1}"
    _arr[$x]="$new_row"
    eval "$1=(\"\${_arr[@]}\")"  # Update the original array passed as argument
    update_world "$1"
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
    update_world "$_arr"
}

main() {
    trap "check_terminal_size;print_world map" SIGWINCH
    # Call the functions

    check_terminal_size
    build_walls map
    update_world map
    print_world map

    while :; do
        sleep .1
    done
}

# main

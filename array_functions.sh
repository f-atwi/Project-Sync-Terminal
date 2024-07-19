get_len(){
    local _arr="$1"
    local len="${#_arr[@]}"
    echo "$len"
}
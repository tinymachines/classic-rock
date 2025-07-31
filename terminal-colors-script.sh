#!/bin/bash
#
# Terminal Colors Greatest Hits
# A collection of the finest terminal color code snippets
#
# Attribution:
# Source: Unix & Linux Stack Exchange
# URL: https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
# Post ID: 269077
# Site: unix.stackexchange.com
#
# This script organizes various terminal color demonstrations and utilities
# from the Stack Exchange community into a single, parameterized tool.
#

# Function to show usage
show_usage() {
    cat << EOF
Terminal Colors Greatest Hits

Usage: $0 [OPTION]

Options:
    basic8      Show basic 8 colors (foreground and background)
    256         Show all 256 colors in a single line
    256ordered  Show 256 colors in an ordered, numbered grid
    16mil       Test console's 16 million color capability
    rgbtable    Show RGB color table samples
    fromhex     Convert hex color to 0-255 color index
                Usage: $0 fromhex #RRGGBB
    tohex       Convert color index (0-255) to hex
                Usage: $0 tohex NUMBER
    all         Run all color demonstrations
    help        Show this help message

Examples:
    $0 basic8
    $0 fromhex #00fc7b
    $0 tohex 125

Attribution:
    Stack Exchange Post: https://unix.stackexchange.com/questions/269077/
    Site: unix.stackexchange.com
EOF
}

# Basic 8 colors display
show_basic8() {
    echo "=== Basic 8 Colors ==="
    echo "Foreground colors:"
    printf '\e[%sm▒' {30..37} 0; echo
    echo -e "\nBackground colors:"
    printf '\e[%sm ' {40..47} 0; echo
    echo -e "\nColor names:"
    echo "0: black   1: red     2: green   3: yellow"
    echo "4: blue    5: magenta 6: cyan    7: white"
    echo
}

# Show all 256 colors in one line
show_256colors() {
    echo "=== All 256 Colors ==="
    printf '\e[48;5;%dm ' {0..255}
    printf '\e[0m \n'
    echo
}

# Show 256 colors in ordered, numbered format
show_256ordered() {
    echo "=== 256 Colors (Ordered & Numbered) ==="
    
    color(){
        for c; do
            printf '\e[48;5;%dm%03d' $c $c
        done
        printf '\e[0m \n'
    }
    
    IFS=$' \t\n'
    color {0..15}
    for ((i=0;i<6;i++)); do
        color $(seq $((i*36+16)) $((i*36+51)))
    done
    color {232..255}
    echo
}

# Test 16 million colors capability
test_16mil() {
    echo "=== 16 Million Colors Test ==="
    echo "Testing console's capability to display 16 million colors..."
    echo "You should see a subtle gradient from darker to lighter red:"
    
    for r in {200..255..5}; do 
        fb=4;g=1;b=1
        printf '\e[0;%s8;2;%s;%s;%sm ' "$fb" "$r" "$g" "$b"
    done
    echo -e '\e[0m'
    
    echo -e "\nBasic syntax: \\e[0;38;2;R;G;Bm (foreground) or \\e[0;48;2;R;G;Bm (background)"
    echo "Where R, G, and B are values from 0 to 255"
    echo
}

# Mode 2 header for RGB table
mode2header(){
    printf '\e[mR\n' # reset the colors.
    printf '\n\e[m%59s\n' "Some samples of colors for r;g;b. Each one may be 000..255"
    printf '\e[m%59s\n' "for the ansi option: \e[0;38;2;r;g;bm or \e[0;48;2;r;g;bm :"
}

# Mode 2 colors display
mode2colors(){
    # foreground or background (only 3 or 4 are accepted)
    local fb="$1"
    [[ $fb != 3 ]] && fb=4
    local samples=(0 63 127 191 255)
    
    for r in "${samples[@]}"; do
        for g in "${samples[@]}"; do
            for b in "${samples[@]}"; do
                printf '\e[0;%s8;2;%s;%s;%sm%03d;%03d;%03d ' "$fb" "$r" "$g" "$b" "$r" "$g" "$b"
            done
            printf '\e[m\n'
        done
        printf '\e[m'
    done
    printf '\e[mReset\n'
}

# Show RGB color table
show_rgbtable() {
    echo "=== RGB Color Table ==="
    mode2header
    echo -e "\nForeground colors:"
    mode2colors 3
    echo -e "\nBackground colors:"
    mode2colors 4
    echo
}

# Convert hex to color index
fromhex(){
    local hex=${1#"#"}
    local r=$(printf '0x%0.2s' "$hex")
    local g=$(printf '0x%0.2s' ${hex#??})
    local b=$(printf '0x%0.2s' ${hex#????})
    local index=$(( (r<75?0:(r-35)/40)*6*6 + 
                    (g<75?0:(g-35)/40)*6 + 
                    (b<75?0:(b-35)/40) + 16 ))
    printf '%03d' "$index"
}

# Convert color index to hex
tohex(){
    local dec=$(($1%256)) ### input must be a number in range 0-255.
    
    if [ "$dec" -lt "16" ]; then
        local bas=$(( dec%16 ))
        local mul=128
        [ "$bas" -eq "7" ] && mul=192
        [ "$bas" -eq "8" ] && bas=7
        [ "$bas" -gt "8" ] && mul=255
        local a="$(( (bas&1) *mul ))"
        local b="$(( ((bas&2)>>1)*mul ))"
        local c="$(( ((bas&4)>>2)*mul ))"
        printf 'dec= %3s basic= #%02x%02x%02x\n' "$dec" "$a" "$b" "$c"
    elif [ "$dec" -gt 15 ] && [ "$dec" -lt 232 ]; then
        local b=$(( (dec-16)%6 )); b=$(( b==0?0: b*40 + 55 ))
        local g=$(( (dec-16)/6%6)); g=$(( g==0?0: g*40 + 55 ))
        local r=$(( (dec-16)/36 )); r=$(( r==0?0: r*40 + 55 ))
        printf 'dec= %3s color= #%02x%02x%02x\n' "$dec" "$r" "$g" "$b"
    else
        local gray=$(( (dec-232)*10+8 ))
        printf 'dec= %3s gray= #%02x%02x%02x\n' "$dec" "$gray" "$gray" "$gray"
    fi
}

# Run all demonstrations
run_all() {
    show_basic8
    show_256colors
    show_256ordered
    test_16mil
    show_rgbtable
}

# Main script logic
case "$1" in
    basic8)
        show_basic8
        ;;
    256)
        show_256colors
        ;;
    256ordered)
        show_256ordered
        ;;
    16mil)
        test_16mil
        ;;
    rgbtable)
        show_rgbtable
        ;;
    fromhex)
        if [ -z "$2" ]; then
            echo "Error: Please provide a hex color value"
            echo "Usage: $0 fromhex #RRGGBB"
            exit 1
        fi
        result=$(fromhex "$2")
        echo "Hex $2 → Color index: $result"
        ;;
    tohex)
        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -gt 255 ]; then
            echo "Error: Please provide a number between 0 and 255"
            echo "Usage: $0 tohex NUMBER"
            exit 1
        fi
        tohex "$2"
        ;;
    all)
        run_all
        ;;
    help|"")
        show_usage
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

# Reset colors at the end
printf '\e[0m'

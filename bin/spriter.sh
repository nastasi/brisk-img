#!/bin/bash
#
#  Max height in play area 121 px
#

if [ $# -ne 3 -o "$1" = "-h" -o "$1" = "--help" ]; then
    echo "$0 <folder_in> <suffix> <file_out_without_extension>"
    exit 1
fi
fold=$1
sfx=$2
fou=$3

w=$(identify -format "%w" ${fold}/00${sfx}.png)
h=$(identify -format "%h" ${fold}/00${sfx}.png)

convert -size $((w * 9))x$((h * 5)) xc:none ${fou}${sfx}_bg.png

argz="${fou}${sfx}_bg.png"

for seed in 0 1 2 3 4; do
    for card in $(seq 0 9); do
        x=$(((seed * 2 + card / 5) * w)) 
        y=$(((card % 5) * h))
        argz="$argz $(printf "%s/%02d%s.png" "$fold" "$((seed * 10 + card))" "$sfx") -geometry +${x}+${y} -composite "
        if [ $seed -eq 4 ]; then
            break
        fi
    done
done

argz="$argz ${fou}${sfx}.png"
convert $argz

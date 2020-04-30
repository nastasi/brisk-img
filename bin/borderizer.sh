#!/bin/bash

if [ $# -ne 3 -o "$1" = "-h" -o "$1" = "--help" ]; then
    echo "$0 <folder_in> <template_file> <suffix>"
    exit 1
fi

fold=$1
tmpl=$2
sfx=$3

w=$(identify -format "%w" ${fold}/00${sfx}.png)
h=$(identify -format "%h" ${fold}/00${sfx}.png)

wt=$(identify -format "%w" "${tmpl}")
ht=$(identify -format "%h" "${tmpl}")

x=$(((wt - w) / 2))
y=$(((ht - h) / 2))

for card in $(seq 0 39); do
    convert "$tmpl" $(printf "%s/%02d%s.png" "$fold" "$((seed * 10 + card))" "$sfx") \
            -geometry +${x}+${y} -composite $(printf "%s/%02d_bord%s.png" "$fold" "$((seed * 10 + card))" "$sfx")
done

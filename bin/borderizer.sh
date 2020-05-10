#!/bin/bash

if [ $# -ne 2 -o "$1" = "-h" -o "$1" = "--help" ]; then
    echo "$0 <folder_in> <deck_id>"
    exit 1
fi

fold=$1
deck=$2
template="${fold}/${deck}_src/border_template.png"

w=$(identify -format "%w" ${fold}/00.png)
h=$(identify -format "%h" ${fold}/00.png)

wt=$(identify -format "%w" "$template")
ht=$(identify -format "%h" "$template")

x=$(((wt - w) / 2))
y=$(((ht - h) / 2))

dest_dir="${fold}/${deck}_tmp"

for card in $(seq 0 39); do
    convert "$template" $(printf "%s/%02d.png" "$fold" "$((seed * 10 + card))") \
            -geometry +${x}+${y} -composite $(printf "%s/%02d.png" "$dest_dir" "$((seed * 10 + card))")
done
cp "${fold}/${deck}_src/cover.png" "${dest_dir}/40.png"

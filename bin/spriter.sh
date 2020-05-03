#!/bin/bash
#
#  Max height in play area 121 px
#
# set -x


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
convert -size $((h * 9))x$((w * 5)) xc:none ${fou}${sfx}_oriz_bg.png

convert -size ${w}x${h} xc:none ${fou}${sfx}_empty.png
convert -size ${h}x${w} xc:none ${fou}${sfx}_empty_eawe.png

cssname="${fou}${sfx}.css"
rm -f $cssname
touch $cssname

for direction in "" "_ea" "_we"; do
    horiz_sfx=""
    if [ "$direction" != "" ]; then
        horiz_sfx="_oriz"
    fi
    argz="${fou}${sfx}${horiz_sfx}_bg.png"

    for seed in 0 1 2 3 4; do
        for card in $(seq 0 9); do
            if [ "$direction" = "" ]; then
                x=$(((seed * 2 + card / 5) * w)) 
                y=$(((card % 5) * h))
            else
                x=$(((seed * 2 + card / 5) * h)) 
                y=$(((card % 5) * w))
            fi

            card_id=$(printf "%02d" "$((seed * 10 + card))")
            cat <<EOF >> $cssname
img[data-card-id="${card_id}${direction}"] {
    background: url('img/cards_xx${direction}.png') -${x}px -${y}px;
}

EOF
            
            fin_no=$(printf "%s/%02d%s.png" "$fold" "$((seed * 10 + card))" "$sfx")
            fin=$(printf "%s/%02d%s%s.png" "$fold" "$((seed * 10 + card))" "$sfx" "$direction")
            if [ $seed -lt 4 ]; then
                if [ "$direction" == "" ]; then
                    :
                elif [ "$direction" == "_ea" ]; then
                    convert -rotate 270 "$fin_no" "$fin"
                elif [ "$direction" == "_we" ]; then
                    convert -rotate 90 "$fin_no" "$fin"                
                else
                    exit 1
                fi
            fi
            
            argz="$argz $fin -geometry +${x}+${y} -composite "
            if [ $seed -eq 4 ]; then
                break
            fi
        done
    done
    # full color: argz="$argz ${fou}${sfx}.png"
    argz="$argz +dither -colors 255 ${fou}${sfx}${direction}.png"
    convert $argz
    echo "Created ${fou}${sfx}${direction}.png"
done

rm  ${fold}/[0-3][0-9]${sfx}*.png ${fou}${sfx}_bg.png ${fou}${sfx}_oriz_bg.png

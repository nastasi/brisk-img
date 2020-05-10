#!/bin/bash
#
#  Max height in play area 121 px
#
# set -x


if [ $# -ne 2 -o "$1" = "-h" -o "$1" = "--help" ]; then
    echo "$0 <folder_in> <deck>"
    exit 1
fi
fold=$1
deck=$2

fold_in="${fold}/${deck}_tmp"
fold_ou="${fold}/${deck}_out"

# sfx=$2

w=$(identify -format "%w" ${fold_in}/00.png)
h=$(identify -format "%h" ${fold_in}/00.png)

convert -size $((w * 9))x$((h * 5)) xc:none ${fold_in}/${deck}_bg.png
convert -size $((h * 9))x$((w * 5)) xc:none ${fold_in}/${deck}_oriz_bg.png

convert -size ${w}x${h} xc:none ${fold_ou}/cards_${deck}_empty.png
convert -size ${h}x${w} xc:none ${fold_ou}/cards_${deck}_empty_ea.png
cp ${fold_ou}/cards_${deck}_empty_ea.png ${fold_ou}/cards_${deck}_empty_we.png
cssname="${fold_ou}/cards_${deck}.css"
rm -f $cssname
touch $cssname

for direction in "" "_ea" "_we"; do
    horiz_sfx=""
    if [ "$direction" != "" ]; then
        horiz_sfx="_oriz"
    fi
    argz="${fold_in}/${deck}${horiz_sfx}_bg.png"

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
            if [ "$card_id" = "40" ]; then
                card_id="cover"
            fi
            card_url="img/cards_${deck}"
            cat <<EOF >> $cssname
img[data-card-id="${card_id}${direction}"] {
    background: url('${card_url}${direction}.png') -${x}px -${y}px;
}

EOF
            
            if [ "$card_id" = "40" ]; then
                fin_no=$(printf "%s/%s_src/cover${direction}.png" "$fold_in" "$deck" "$((seed * 10 + card))")
                fin=$(printf "%s/%02d%s.png" "$fold_in" "$((seed * 10 + card))" "$direction")
                if [ "$direction" == "" ]; then
                    cp "$fin_no" "$fin"
                fi
            else
                fin_no=$(printf "%s/%02d.png" "$fold_in" "$((seed * 10 + card))")
                fin=$(printf "%s/%02d%s.png" "$fold_in" "$((seed * 10 + card))" "$direction")
            fi
            if [ "$direction" == "" ]; then
                :
            elif [ "$direction" == "_ea" ]; then
                convert -rotate 270 "$fin_no" "$fin"
            elif [ "$direction" == "_we" ]; then
                convert -rotate 90 "$fin_no" "$fin"                
            else
                exit 1
            fi
            
            argz="$argz $fin -geometry +${x}+${y} -composite "
            if [ $seed -eq 4 ]; then
                break
            fi
        done
    done
    # full color: argz="$argz ${fold_ou}${deck}.png"
    full_out="${fold_ou}/cards_${deck}${direction}.png"
    argz="$argz +dither -colors 255 $full_out"
    convert $argz
    echo "Created $full_out"
done

# rm  ${fold}/[0-3][0-9]${deck}*.png ${fold_ou}${deck}_bg.png ${fold_ou}${deck}_oriz_bg.png

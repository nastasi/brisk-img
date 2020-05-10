#!/bin/bash

declare -A folders

folders=( [single_cards_xx]="xx nb" [single_cards_yy]="yy" )

for folder in ${!folders[@]}; do
    for deck in ${folders[$folder]}; do
        ./bin/borderizer.sh "briskin5/$folder" $deck
        ./bin/spriter.sh "briskin5/$folder" $deck
    done
done


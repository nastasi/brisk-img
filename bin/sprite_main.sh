#!/bin/bash
./bin/borderizer.sh briskin5/img briskin5/img/with_border_template.png ""
./bin/spriter.sh briskin5/img "_bord" briskin5/img/cards_xx
geeqie briskin5/img/cards_xx_bord.png


./bin/borderizer.sh briskin5/img briskin5/img/with_border_template_side.png "_ea"
./bin/spriter.sh briskin5/img "_bord_ea" briskin5/img/cards_xx
geeqie briskin5/img/cards_xx_bord_ea.png

./bin/borderizer.sh briskin5/img briskin5/img/with_border_template_side.png "_we"
./bin/spriter.sh briskin5/img "_bord_we" briskin5/img/cards_xx
geeqie briskin5/img/cards_xx_bord_we.png

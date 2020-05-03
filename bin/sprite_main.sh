#!/bin/bash
./bin/borderizer.sh briskin5/single_cards_xx briskin5/single_cards_xx/with_border_template.png ""
./bin/spriter.sh briskin5/single_cards_xx "_bord" briskin5/img/cards_xx

./bin/borderizer.sh briskin5/single_cards_yy briskin5/single_cards_yy/with_border_template.png ""
./bin/spriter.sh briskin5/single_cards_yy "_bord" briskin5/img/cards_yy

#!/bin/bash
#
# Defaults
#
n_players=3
ftok_path="/var/lib/brisk"
web_path="$HOME/brisk"
web_only=0

if [ -f $HOME/.brisk_install ]; then
   . $HOME/.spawn_install
fi

function usage () {
    echo
    echo "$1 [-p|--package]"
    echo "$1 [-n 3|5] [-w web_dir] [-k <ftok_dir>] [-W]"
    echo "  -p build \"binary\" version of the package"
    echo "  -h this help"
    echo "  -n number of players - def. $n_players"
    echo "  -w dir where place the web tree - def. \"$web_path\""
    echo "  -k dir where place ftok files   - def. \"$ftok_path\""
    echo "  -W install web files only"
    echo
}

function get_param () {
    echo "X$2" | grep -q "^X$1\$"
    if [ $? -eq 0 ]; then
	# echo "DECHE" >&2
        echo "$3"
	return 2
    else
	# echo "DELA" >&2
        echo "$2" | cut -c 3-
        return 1
    fi
    return 0
}

#
#  MAIN
#
if [ "$1" = "-p" -o "$1" = "--package" ]; then
   cd ..
   tar zcvf brisk-img.tgz `find brisk-img -name INSTALL.sh -o -name '*.png' -o -name '*.jpg' -o -name '*.gif' -o -name '.htaccess' | grep -v '/src_'`
   cd -
   exit 0
fi

while [ $# -gt 0 ]; do
    # echo aa $1 xx $2 bb
    case $1 in
	-n*) n_players="`get_param "-n" "$1" "$2"`"; sh=$?;;
	-w*) web_path="`get_param "-w" "$1" "$2"`"; sh=$?;;
	-k*) ftok_path="`get_param "-k" "$1" "$2"`"; sh=$?;;
	-W) web_only=1;;
	-h) usage $0; exit 0;;
	*) usage $0; exit 1;;
    esac
    # echo "SH $sh"
    shift $sh
done

#
#  Show parameters
#
echo "    web_path:  \"$web_path\""
echo "    ftok_path: \"$ftok_path\""
echo "    n_players:   $n_players"


for i in `find -type d -name 'img'`; do
    ii="`echo "$i" | cut -c 3- `"
    install -d ${web_path}/$ii
    install -m 644 `find $ii -name INSTALL.sh -o -name '*.png' -o -name '*.jpg' -o -name '*.gif' -o -name '.htaccess' | grep -v '/src_'` ${web_path}/$ii
done


exit 0

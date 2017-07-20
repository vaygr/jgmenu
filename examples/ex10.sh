#!/bin/sh

test -e $PWD/ex-sh-setup.sh && . ${PWD}/ex-sh-setup.sh 2>/dev/null || { echo "fatal: not run from examples/"; exit 1; }

tint2dirs="/usr/share/tint2 /usr/local/share/tint2"
tint2dir=

for d in ${tint2dirs}
do
	if test -d ${d}
	then
		tint2dir=${d}
		break;
	fi
done
echo ${tint2dir}
test -z ${tint2dir} && { echo "fatal: cannot find tint2rc files"; exit 1; }
cd ${tint2dir}

printf "%b\n" "########################"
printf "%b\n" "#  F10=next; F9=abort  #"
printf "%b\n" "########################"

for f in ./*.tint2rc
do
	printf "%b\n" "${tint2dir}/${f##./}"
#	printf "%b\n" "Press ENTER to run tint2+jgmenu, or CTRL+C to abort"
#	read a
	restart_tint2 "${f}"
	killall jgmenu 2>/dev/null
	TINT2_CONFIG=${f} jgmenu --csv-cmd="jgmenu_run parse-pmenu" \
				 --config-file= 2>/dev/null || exit 1
done

restart_tint2
killall jgmenu 2>/dev/null

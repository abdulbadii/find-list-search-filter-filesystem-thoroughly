#!/usr/bin/bash
unset S n s nn sn
TMOUT=$'\x0a'
N=${BASH_SOURCE[0]};dir=`dirname "$N"`
[[ `sed -En '/\s#{5,}\s*BEGINNING OF l, find/{=;p;q}' ~/.bashrc` =~ ^([0-9]+)[[:space:]]+(.+) ]];
n=${BASH_REMATCH[1]}
s="${BASH_REMATCH[2]}"
[[ `sed -En '/\s#{5,}\s*ENDING OF l, find/{=;p;q}' ~/.bashrc` =~ ^([0-9]+)[[:space:]]+(.+) ]];
nn=${BASH_REMATCH[1]}
sn="${BASH_REMATCH[2]}"
T=list-su.sh
if((n));then
	((nn)) ||{ echo But broken as its end mark was not found;return;exit;}
	echo -e "\nAttention, the pattern:\n\n\t\'$s\'\n\nwas found in ~.bashrc at line number $n till line $nn:\n\n\t$sn"
	if [ "$1" = -r ] ;then
		echo -e "\nYou commanded to uninstall/remove it from ~/.bashrc. "
		read -sN1 -p 'Confirm (Enter: yes) ? ' o;[ "$o" = $'\x0a' ]&&{
			echo Removing the script functions start from the header pattern...
			sed -i -Ee '/$s/,/$sn/d' ~/.bashrc
		}
	else
		echo -ne "\nUpdating, copying default $T to replace its previous one starts at line $n of ~/.bashrc...\n\nHit u key in 5s to have installation for user without sudo, otherwise key now or after time is out it'd install with sudo... "
		read -N1 -t5 o;	[ "$o" = u ]&&T=list.sh
		if [ "$1" = -n?* ]	;then	m=${1:2}
			echo -ne "\nYou commanded to update, install it as function name $m... "
			sed -e "$n e sed 's/^l\\(\\)\\{/$m(){/' $T" -e "$n,${nn}d" ~/.bashrc &&echo done now, invoke it by $m
		else
			sed -i -Ee "${n}r$T" -e "$n,${nn}d" ~/.bashrc;fi
	fi
else
	for e;{
	case "$e" in
	-n) m=${e:2}
		echo -e "\nYou commanded to install it as function name $m... "
		sed -e "$n e sed 's/^l\\(\\)\\{/$m(){/' $T" -e "$n,${nn}d" ~/.bashrc &&echo done now, invoke it by $m;;
	-[1-9]*)	n=${e:1}
		if [ $n = 1 ] ;then
			sed -i -Ee "1{r$T" -e 'h;d};2{x;G}' ~/.bashrc
		else
			sed -i -Ee "$((n-1))r$T" ~/.bashrc;fi
		break;;
	-p?*)
		p=${e:2}
		sed -i -nEe "/$p/{h;r$T" -e 'n;x;G};p'  ~/.bashrc;;# or "/$p/r$T" -e '1x;2,${x;p};${g;p}'
	-u)T=list.sh;break;;
	*)
	echo -e "Not found a line with pattern\n\t"$s\"\nas the header mark\nPlease command with the usage below to insert $T to ~/.bashrc or just hit Enter on next"
	echo -e "\nUsage to copy/insert \"$T\" into \"$HOME/.bashrc\" is to position such:\n"
	echo -e "\n - At line number:       $N -{1 ..999}\n - At line with pattern:   $N -p{pattern string}"
	echo -e "\n - Set tool/function name else than 'l':  $N -n{string}\n\t e.g. $N -nfd"
	echo -e "\n - The sudo/root privilege is always on when using this, to install one without it, put -u as first option such\n $N -u ...\n\n"
	read -sN1 -p "Copy $T onto the first line of ~/.bashrc (Enter: yes, else: no)? " o
	[ "$o" = $'\x0a' ]&&{
		read -N1 -t5 -p "Installing at first position of ~/.bashrc. Default to install with sudo, hit u key to be user without sudo " o
		[ "$o" = u ]&&T=list.sh
		sed -i -Ee "1{r$T" -e 'h;d};2{x;G}' ~/.bashrc
	}
	esac
	}
fi #return;exit

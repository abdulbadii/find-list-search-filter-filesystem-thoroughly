#!/usr/bin/bash
unset S n s nn sn TMOUT

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
	echo -e "\nAttention, the pattern:\n\n\'$s\'\n\nwas found in ~.bashrc at line number $n till line $nn:\n\t$sn"
	if [ "$1" = -r ] ;then
		echo -e "\nYou commanded to remove (uninstall) it from ~/.bashrc by\n\t$N -r\n"
		read -sN1 -p 'Confirm (Enter: yes) ? ' o;[ "$o" = $'\x0a' ]&&{
			echo Removing the script functions start from the header pattern...
			sed -i -Ee '/$s/,/$sn/d' ~/.bashrc
		}
	else
		echo -e "\nUpdating, copying $T replacing its previous one starts at line $n of ~/.bashrc...\nPress u in 3 seconds to choose to user-level one without the sudo, or hit Enter to do instantly"
		read -N1 -t 3 o;	[ "$o" = u ]&&T=list.sh
		sed -i -Ee "$((--n))r$T" -e "$n,/${sn/+/\\+}/d" ~/.bashrc
	fi
else
	for e;{
	case "$e" in
	-[1-9]*)	n=${1}
		if [ $n = 1 ] ;then
			sed -i -Ee "1{r$T" -e 'x};2{x;G}' ~/.bashrc
		else
			sed -i -Ee "$((n-1))r$T" ~/.bashrc 
		fi;;
	-p?*)
		p=${1:2}
		sed -i -nEe "/$p/{x;r$T" -e 'n;x;G};p'  ~/.bashrc;;
		# or "/$p/r$T" -e '1x;2,${x;p};${g;p}'
	-u) T=list.sh;;
	*)
	echo -e 'Not found a line with pattern\n\t\t"##### BEGINNING OF l, find"\nas the header mark\nPlease use CL below to insert $T to ~/.bashrc or just hit Enter on next'
	echo -e "\nUsage to copy/insert \"$T\" into \"$HOME/.bashrc\" is to position such:\n"
	echo -e "\n - At line number:       $0 -n{1 ..999}\n - At line with pattern:   $0 -p{pattern string}"
	echo -e "\n - The sudo/root privilege is always ready when using it to install without it put -u as first option such\n $N -u ..."
	read -sN1 -p "Copy $T onto the first line of ~/.bashrc (Enter: yes, else: no)? " o
	[ "$o" = $'\x0a' ]&&{
		read -sN1 -p "One with sudo or not (Enter: with sudo, else: no)? " o
		if [ "$o" = $'\x0a' ];then T=list-su.sh ;else T=list.sh ;fi
		sed -i -Ee "1{r$T" -e 'x};2{x;G}' ~/.bashrc
	}
	esac
	}
fi #return;exit

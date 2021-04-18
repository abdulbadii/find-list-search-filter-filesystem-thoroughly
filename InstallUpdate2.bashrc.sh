#!/usr/bin/bash
unset S n s nn sn F
TMOUT=$'\x0a'
N=${BASH_SOURCE[0]};dir=$(cd `dirname "$N"`&&pwd)
[[ `sed -En '/\s#{5,}\s*BEGINNING OF l, find/{=;p;q}' ~/.bashrc` =~ ^([0-9]+)[[:space:]]+(.+) ]];
n=${BASH_REMATCH[1]}
s="${BASH_REMATCH[2]}"
[[ `sed -En '/\s#{5,}\s*ENDING OF l, find/{=;p;q}' ~/.bashrc` =~ ^([0-9]+)[[:space:]]+(.+) ]];
nn=${BASH_REMATCH[1]}
sn="${BASH_REMATCH[2]}"
T=list-su.sh
if((n));then
	((nn)) ||{ echo But broken as its end mark was not found;return;exit;}
	echo -e "\nAttention: the pattern:\n\n\t\'$s\'\n\nwas found in ~/.bashrc at line number $n till line $nn:\n\n\t$sn"
	if [ "$1" = -r ] ;then
		read -sN1 -p 'Confirm  to uninstall/remove it from ~/.bashrc. (Enter: yes) ? ' o;[ "$o" = $'\x0a' ]&&{
			echo Removing the tool script from ~/.bashrc start from line $n up to line $nn...
			sed -i -e "$n,${nn}d" ~/.bashrc
		}
	else
		echo;echo Updating from github...
		git pull ||{	d=find-list-search-filter-filesystem-thoroughly
			git clone --depth 1 https://github.com/abdulbadii/$d; pushd $dir/$d;F=1;}
		echo -ne "\nUpdating, copying $T to replace its previous one starts at line $n in ~/.bashrc...\n\nHit u key in 5 s to have installation for user without sudo. Otherwise now or after timeout would install with sudo... "
		read -N1 -t5 o;	[ "$o" = u ]&&T=list.sh
		if [ "$1" = -n?* ]	;then
			m=${1:2};	sed -i -e "$n e sed 's/^l\\(\\)\\{/$m(){/' $T" -e "$n,${nn}d" ~/.bashrc
		else	m=l;	sed -i -e "${n}r$T" -e "$n,${nn}d" ~/.bashrc;fi
		((F))&&popd
	fi
	(($?))||echo -ne "\nUpdating, confirming the tool name as \"$m\" ...done, now should be invoked by: $m"
else
	echo -e "\nNot found a line with pattern\n\t\"$s\"\nas the header mark"
	for e;{
	case "$e" in
	-n) m=${e:2}
		echo -ne "\nYou commanded to install it as function name $m... "
		sed -e "$n e sed 's/^l\\(\\)\\{/$m(){/' $T" -e "$n,${nn}d" ~/.bashrc &&echo done, now should be invoked by: $m;;
	-[1-9]*)	n=${e:1}
		if [ $n = 1 ] ;then
			echo -ne "\nInstalling at first position of ~/.bashrc... "
			sed -i -ne "r$T" -e 'h;n;x;G;:o p;n;bo' ~/.bashrc &&echo done
		else
			echo -ne "\nYou commanded to install it at line number $n... "
			sed -i -e "$((n-1))r$T" ~/.bashrc &&echo done
		fi;break;;
	-p?*)
		p=${e:2}
		sed -i -e "/$p/{r$T" -e 'bo};b;:o n;bo'  ~/.bashrc
		break;;
	-u)T=list.sh;;
	*)
	echo -e "\nPlease command using instruction below to install/insert $T to ~/.bashrc, or just hit Enter on next\n"
	echo -e "\nUsage to install or copy/insert \"$T\" into \"$HOME/.bashrc\" is to position such:\n"
	echo -e "\n - At line number:       $N -{1 ..999}\n - At line with pattern:   $N -p{pattern string}"
	echo -e "\n - Set this tool name which wil be invoked with, else than 'l' as default\nThe name may not be:fx, fxr, fdt, fsz, ftm and fid\n\t$N -n{string}\n\t e.g. $N -nfd   will let user to invoke this by: fd"
	echo -e "\n - The sudo/root privilege mode defaults to be installed, to install one without it, put -u as first option such\n $N -u ...\n\n"
	read -sN1 -p "Copy, insert $T onto the first line of ~/.bashrc (Enter: yes, else: no)? " o
	[ "$o" = $'\x0a' ]&&{
		read -N1 -t5 -p "Installing one with sudo... hit u key in 5 s to install one without sudo " o
		[ "$o" = u ]&&T=list.sh
		sed -i -ne "r$T" -e 'h;n;x;G;:o p;n;bo' ~/.bashrc
	}
	esac
	}
fi;. ~/.bashrc


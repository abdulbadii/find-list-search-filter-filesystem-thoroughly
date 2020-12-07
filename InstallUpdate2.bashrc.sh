#!/usr/bin/bash
unset s
for o;{ [ $o = -s ] &&s=-su ;}

n=`sed -En '/\s#{5,}\s*BEGINNING OF l, find wrap script #{5,}/{=;q}' ~/.bashrc`
if((n));then
	echo -e "Warning:\n\t\t##### BEGINNING OF l, find wrap script #####\n\npattern was found in ~.bashrc at line number $n\n"
	echo -e "\nCommand to remove/uninstall it:   $0 -r)"
	if [ "$1" = -r ] ;then
		echo removing l function script from that header pattern
		sed -i -Ee '/\s+#{5,}\s*BEGINNING OF l, find wrap script #{5,}/,/^\}\s+#{5,}\s*ENDING OF l, find /d' ~/.bashrc
	else
		echo copying list$s.sh, and writing it, replacing part of text starting at line $n
		sed -i -Ee "$((--n))rlist$s.sh" -e "$n,/#{5,}\s+ENDING OF l, find/d" ~/.bashrc
	fi 
else
	case "$1" in
	-n[1-9]*)	n=${1:2}
		if [ $n = 1 ] ;then
			sed -i -Ee "1{rlist$s.sh" -e 'x};2{x;G}' ~/.bashrc
		else
			sed -i -Ee "$((n-1))rlist$s.sh" ~/.bashrc 
		fi;;
	-p?*)
		p=${1:2}
		sed -i -Ene "/$p/{x;rrlist$s.sh" -e 'n;x;G};p'  ~/.bashrc;;
		# or "/$p/rlist$s.sh" -e '1x;2,${x;p};${g;p}'
	*)
	echo -e 'Not found line with pattern\n\t\t"##### BEGINNING OF l, find wrap script #####"\nas the header mark... try to install/copy list.sh as the first time'
	echo -e "\nInstaller usage to copy/insert \"list.sh\" into \"$HOME/.bashrc\" is to position such:\n"
	echo -e " - At line number:       $0 -n{1 ..999}\n - At certain pattern:   $0 -p{pattern string}"
	echo -e "\n - if sudo/root privilege is needed, install by adding -s:\n $0 -s ..."
	esac
fi

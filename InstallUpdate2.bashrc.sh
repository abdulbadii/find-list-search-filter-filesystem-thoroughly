#!/usr/bin/bash
unset s
for o;{ [ $o = -s ] &&s=-su ;}

n=`sed -En '/\s+#{5,}\s*BEGINNING OF l, find wrap script #{5,}/{=;q}' ~/.bashrc`
if((n));then
	echo -e "\n\t\t##### BEGINNING OF l, find wrap script #####\n\npattern was found in ~.bashrc at line number $n, copying/updating onto there"
	sed -Ee "$((--n))rlist$s.sh" -e "$n,/#{5,}\s+END l, find/d" ~/.bashrc 
else
	case \"$1\" in
	-n[1-9]*)	n=${1:2}
		if [ $n = 1 ] ;then
			sed -Ee "1{rlist$s.sh" -e 'x};2{x;G}' ~/.bashrc
		else
			sed -Ee "$((n-1))rlist$s.sh" ~/.bashrc 
		fi;;
	-p?*)
		p=${1:2}
		sed -Ene "/$p/rlist$s.sh" -e 1x -e '2,${x;p}' -e '${g;p}' ~/.bashrc;;
	*)
	echo -e 'Not detected line with pattern\n\t\t"##### BEGINNING OF l, find wrap script #####"\nas the header mark... try to install/copy for the first time'
	echo -e "\nInstaller usage to copy/insert \"list.sh\" into \"$HOME/.bashrc\" is to position such:\n"
	echo -e " - At line number:       $0 -n{1 ..999}\n - At certain pattern:   $0 -p{pattern string}"
	echo -e "\n - if sudo/root privilege is needed, install list-su.sh instead (add -s):\n $0 -s ..."
	esac
fi

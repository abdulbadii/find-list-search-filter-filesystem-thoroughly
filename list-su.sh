fx(){
for e;{
unset local b B LO M s a p re z
[[ $e =~ ^\.?/[^/] ]]||re=1
e=${e#./}
: ${se='\\\\'}
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
while [[ $e =~ ([^\\]|^)(\\[^\\]|\\$) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
LO=\"${BASH_REMATCH[4]}\"
z=${BASH_REMATCH[5]}
while [[ $LO =~ ^"\.\."$ ]] ;do B=$B../;LO=*$z;done
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	LO=$LO\ $@;F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}

unset IFS;eval set -- $LO
for a;{
a=$B${a%%+(/)}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root >&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
else
	s=~+
	p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
p=${p%/}
b=${p%/*}
p=${p##*/}$z$M
i=;IFS=$'\n';eval set -- $p
for f;{
[[ $f =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
p=$b${BASH_REMATCH[1]}
if((E)) ;then
	while [[ $s =~ ([^\\]|^)([.*?{}().]) ]] ;do s=${s/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
else
	while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^\]\\*])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	p=${p//\*\*/.*}
fi
case $z in
/)	z=" -type d";;
//)	z=" -type f";;
///)	z=\ -executable;;
////)	z=" -type l";;
esac
if((re)) ;then	X=\"$s.*$p\"\ $z
else	X=\"$s$p\"\ $z
fi
}
}
}
}
fd(){
for i
{
	[[ `file "$i"` =~ ^[^:]+:\ *([^,]+$|[^,]+\ [^,]+) ]]
	echo -e " ${BASH_REMATCH[1]}\n DEPs"
	ldd "$i" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
}
l(){
unset IFS a po opt se E sz t dt l lh lx cp cpe i j if F; X=\'\';I=i;J=i ;de=0
set -f;trap 'set +f;unset IFS' 1 2
shopt -s extglob
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-[cam]min|-[cam]time|-newer|-newer[aBcmt]?|-anewer|-type|-xtype|-size|-use[dr]|-group|-uid|-perm|-links|-fstype|-context|-samefile )
	opt=$opt$e\ ;F=1;;
-[1-9]|-[1-9][0-9]) dt=-maxdepth\ ${e:1};;
-[1-9]-*|[1-9][0-9]-*)
	dt=${e#-}
	z=${dt#*-}
	dt="-mindepth ${dt%-*}${z:+ -maxdepth $z}";;
-cp=?*|-cpu=?*) Fc=1;;
-x=?*) Fx=1;;
-xs=?*|-x-s=?*|-xcs=?*|-x-cs=?*) Fx=1;J=;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]|-l[1-9][0-9])
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-E|-re) E=1;;
-s)	sz=%s\ ;;
-t)	t="%Tr %Tx ";;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[ac-il-w]) echo \'$e\' : inadequate more specific option, ignoring;;
-h|--help) man find;return;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring;;
-[!-]*) echo \'$e\' : unknown option, ignoring. If it\'s meant a path name, put it after - or -- and space;;
-[HDLPO]) po=$e;;
*) break;;
esac
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
c=${BASH_REMATCH[1]}
while [[ $c =~ ([^\\])[\;|\>\<] ]] ;do c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done
IFS=$'\n';set -- $c
unset IFS
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{	
	c="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
	eval set -- $c
	break;}
	set --
}
for a;{
case $a in
	-x=?*|-xs=?*|-xcs=?*|-x-s=?*|-x-cs=?*)
		[[ $a =~ ^-x-?c?s=(.+)$ ]]
		shift;c=("$@")					# Preserve array to c
		eval set -- ${BASH_REMATCH[1]}
		fx "$@"
		eval set -- "${c[@]}";;
	-cp=?*|-cpu=?*)
		
		;;
	-|--)	shift;break;;
	-*)	shift;;
	*)	break;;
esac
}
[ "$1" ] || set -- ''
P="\( -path '* *' -printf \"$sz$t'%p'\n\" -o -printf \"$sz$t%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$t'%p/'\n\" -o -printf \"$sz$t%p/\n\" \)"
((l)) &&{
 [ -z $lx ]&&lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
for e;{
unset b B LO M s re
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or else, in same dir, if any, and none has exact .. pattern
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
#get common base dir. path (B) if any
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
z=${BASH_REMATCH[5]}
LO=\"${BASH_REMATCH[4]}\"
while [[ $LO =~ ^"\.\."$ ]] ;do B=$B../;LO=*$z;done
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	LO=$LO\ $@;F=;break;};}

[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}
unset IFS s
eval set -- ${LO-\"\"}
for a;{
a=$B${a%%+(/)}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	p=$a
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)?$ ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid path: $a. It goes up beyond root >&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
else
	s=~+
	p=${a:+/$a}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
p=${p%/}

d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\]\\*])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
p=${p//\*\*/.*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=\"${b##*$'\v'}${z//\//$'\v'}$M\"
b=\"${b%$'\v'*}\"
i=;eval set -- ${p:-\"\"}
for f;{
unset F;R=.*
[ "$f" ] &&{
if((!E)) &&[[ $f =~ ([^\\]|^)[[*?] ]] ;then
	[[ $f =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	f=$b$'\v'${BASH_REMATCH[1]}
	if((re)) ;then	p=.*$f
	else
		[[ $f =~ ^([^[*?]*)($'\v'.+)$ ]]
		s=$s${BASH_REMATCH[1]//$'\v'/\/}
		p=${BASH_REMATCH[2]}
	fi
	R=\".{${#s}}${p//$'\v'/\/}\"
else
	[[ ${r[$i]} =~ ^(.*[^/])?(/*)$ ]]
	f=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	f=$d${f:+/$f}
	if((E)) ;then
		if((re)) ;then R=\"{${#s}}.*$f\"
		else	R=\"$s$f\" ;fi
	elif((re)) ;then	F=1
	else
		s=$s$f
		[ -d $s ] ||{ R=\"$s\";s=${s%/*};}
		
	fi
fi
: ${s:=/}
}
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="-executable $P";;
////)	Z="-type l $P";;
*)	Z="\( $PD -o $P \)";;
esac
((F))&&{
	R="\".{${#s}}$f\" \( -type d -exec find '{}' $dt $opt $Z \; -o $P \)"${f:+" -o -${I}regex \".{${#s}}.+$f\" \( $PD -o $P \)"}; Z=
}
export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	export -f fd
	eval "find $po \"$s\" $dt \! -path \"$s\" -regextype posix-extended \! -{I}regex \"$X\" $opt -${I}regex $R $P ! -type d -executable -exec /bin/bash -c 'fd \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$s\" $dt \! -path \"$s\" -regextype posix-extended \! -{I}regex \"$X\" $opt -${I}regex $R $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
#elif((Fc)) ;then
	#sudo mkdir -pv $cp
	#eval "sudo find $po $s $dt \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -ft '{}' ${cp[0]}/\{\} \;"
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) eval "sudo find $po \"$s\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$s\" \! \( -${J}regex $X \) $Z"
fi
((i++));}
}
}
set +f;unset IFS
}

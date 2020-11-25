fx(){ ##### BEGINNING OF l, find wrap script ##### 
for e;{
unset local a b B LO M p re z
[[ $e =~ ^\.?/[^/] ]]||re=1
e=${e#./}
: ${se='\\\\'}
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
LO=\"${BASH_REMATCH[4]}\"
z=${BASH_REMATCH[5]}
while [[ $LO =~ \"\.\.\" ]] ;do B=$B../;LO=*$z;done
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	LO=$LO\ \"$@\";F=;break;};}
[ $# -ge 1 ]&&((F)) &&{	[[ $e =~ ^[^$'\n']*($'\n'.*)?$ ]];M=${BASH_REMATCH[1]};}

unset IFS s;eval set -- $LO
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
IFS=$'\n';eval set -- $p
for f;{
[[ $f =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
p=$b${BASH_REMATCH[1]}
if((E)) ;then
	while [[ $s =~ ([^\\]|^)([.*?{}().]) ]] ;do s=${s/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
else
	while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^\]\\*]|^)\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	p=${p//\*\*/.*}
fi
case $z in
/)	z=" -type d";;
//)	z=" -type f";;
///)	z=\ -executable;;
////)	z=" -type l";;
esac
if((re)) ;then	X=("${X[@]} \! -${J}regex \"$s.*$p\" $z")
else	X=("${X[@]} \! -${J}regex \"$s$p\" $z")
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
unset IFS a po opt se E sz t dt l lh lx cp cpu if Fc F X;I=i;J=i ;de=0
set -f;trap 'set +f;unset IFS' 1 2
shopt -s extglob
for e;{
((F)) &&{	opt=$opt$e\ ;F=;continue;}
case $e in
-[cam][mdh][1-9]*|-[cam][mdh]-[1-9]*)
	d=${e#-[cam][mdh]}
	f=${e:2:1}
	L=${d%-*}
	U=${d#*-}
	[ $f = h ] &&{ let U*=60;let L*=60;}
	f=${f/[mh]/min};
	f=${f/d/time}
	f=-${e:1:1}${f/d/time}
	if [[ $d = *-* ]] ;then
		if((!L)) ;then	opt="$opt\( $f -$U -o $f $U \) "
		elif((!U)) ;then	opt="$opt\( $f +$L -o $f $L \) "
		else	opt="$opt\( $f +$L $f -$U -o $f $L -o $f $U \) "
		fi
	else	opt="$opt$f $L "
	fi;;
-[cam]min|-[cam]time)	opt=$opt$e\ ;o=$e;F=1;;
-[1-9]|-[1-9][0-9]) dt=-maxdepth\ ${e:1};;
-[1-9]-*|[1-9][0-9]-*)
	dt=${e#-}
	z=${dt#*-}
	dt="-mindepth ${dt%-*}${z:+ -maxdepth $z}";;
-x=?*) ;;
-xs=?*|-xcs=?*) J=;;
-cp=?*|-cpu=?*) Fc=1;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx='-maxdepth 1'; l=1;;
-l[0-9]|-l[1-9][0-9])
	((${e:2})) &&lx="-maxdepth\ ${e:2}";l=1;;
-E|-re) E=1;;
-s)	sz=%s\ ;;
-t)	t="%Tr %Tx ";;
-h|--help) man find;return;;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring;;
-[HDLPO]) po=$e;;
-[ac-il-x]?*)
	if [[ $e =~ ^-(delete|depth|daystart|follow|fprint.|fls|group|gid|o|xstype)$ ]] ;then opt=$opt$e\ 
	else	read -n1 -p "'$e' is a likely unknown option, ignoring it to continue? " k; [ "$k" = y ]||return
	fi;;
-size|-perm|-inum|-newer|-newer[aBcmt]?|-anewer|-xtype|-type|-use[dr]|-group|-uid|-perm|-links|-fstype|-context|-samefile|-D|-O|-ok|-exec|-execdir|-executable|-ipath|-name|-[il]name|-ilname|-iregex|-path|-m[ai][xn]depth)	opt=$opt$e\ ;F=1;;
-[!-]*) echo \'$e\' : unknown option, ignoring. If it\'s meant a path name, put it after - or -- and space;;
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
	eval set -- ${c//\\/\\\\}
	break;}
	set --
}
for a;{
case $a in
	-x=?*|-xs=?*|-xcs=?*|-x-s=?*|-x-cs=?*)
		[[ $a =~ ^[^=]+=(.+)$ ]]
		shift;c=("$@")					# Preserve array to c
		eval set -- ${BASH_REMATCH[1]//\\/\\\\}
		fx "$@"
		eval set -- "${c[@]}";;
	-cp=?*|-cpu=?*)
		[[ $a =~ ^[^=]+=(.+)$ ]]
		shift;C=("$@");;
	-|--)	shift;break;;
	-*)	shift;;
	*)	break;;
esac
}
[ "$1" ] || set -- ''
for e;{
unset b B LO M s re
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or else, in same dir, if any and...
while [[ $e =~ ([^\\])$se ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
IFS=$'\n';set -- ${e//\\/\\\\}
#get common base dir. path (B) if any
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
z=${BASH_REMATCH[5]}
LO=\"${BASH_REMATCH[4]}\"
while [[ $LO =~ ^"\.\."$ ]] ;do B=$B../;LO=*$z;done
F=1
shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	LO=$LO\ \"$@\";F=;break;};} #..none has exact .. pattern

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
		while [[ $p =~ ^/..(/|$) ]];do
			p=${p#/..}; s=${s%/*};: ${s:=/} ;done
		[[ -z "$s" ]]&&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
p=${p%/}
d=${p%/*};IFS=$'\n';eval set -- \"${p##*/}\"$z$M; r=("$@")
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\]\\*]|^)\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
p=${p//\*\*/.*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}${z//\//$'\v'}$M
b=${b%$'\v'*}
S=$s
i=;IFS=$'\n';set -- ${p:-\"\"}
for f;{
F=;R=.*
[ "$f" ] &&{
if((!E)) &&[[ $f =~ ([^\\]|^)[[*?] ]] ;then
	[[ $f =~ ^(.*[^$'\v'])?($'\v'*)$ ]]
	z=${BASH_REMATCH[2]//$'\v'/\/}
	f=$b$'\v'${BASH_REMATCH[1]}
	if((re)) ;then	p=.*$f
	else
		[[ $f =~ ^([^[*]*)($'\v'.+)$ ]]
		S=$s${BASH_REMATCH[1]//$'\v'/\/}
		: ${S:=/}
		p=${BASH_REMATCH[2]}
	fi
	R=\".{${#S}}${p//$'\v'/\/}\"
else
	[[ ${r[$((i++))]} =~ ^(.*[^/])?(/*)$ ]]
	f=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	f=$d${f:+/$f}
	if((E)) ;then
		if((re)) ;then R=\"{${#S}}.*$f\"
		else	R=\"$S$f\" ;fi
	elif((re)) ;then	F=1
	else
		S=$s$f
		[ -d $s ] ||{ R=\"$S\";S=${s%/*};}
	fi
fi
}
P="\( -path '* *' -printf \"$sz$t'%p'\n\" -o -printf \"$sz$t%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$t'%p/'\n\" -o -printf \"$sz$t%p/\n\" \)"
case $z in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="-executable $P";;
////)	Z="-type l $P";;
*)	Z="\( $PD -o $P \)";;
esac
((l)) &&{
 [ "$lx" ]|| lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
((F)) &&{
	R="\".{${#s}}$f\" \( -type d -exec find '{}' \! -path '{}' $dt $opt $Z \; -o $P \)"${f:+" -o -${I}regex \".{${#s}}.+$f\" \( $PD -o $P \)"}; Z=
}
export LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	export -f fd
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -executable -exec /bin/bash -c 'fd \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
#elif((Fc)) ;then

	mkdir -pv $cp
	#for i in ${C[@]};{
		#eval "find $po \"$s\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$s\" $X -exec cp '{}' $i \;"
	
	#}
	
else
	#command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done)
		eval "find $po \"$S\" $dt -regextype posix-extended $opt -${I}regex $R \! -path \"$S\" $X $Z"
fi
}
}
}
set +f;unset IFS
} ##### ENDING OF l, find wrap script #####

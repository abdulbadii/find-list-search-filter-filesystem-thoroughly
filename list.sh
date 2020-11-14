fx(){
for $1
{
local unset b B In LO L z
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\'}
while [[ $e =~ ([^\\])($se)([^\\]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\015'"${BASH_REMATCH[3]}"} ;done 
while [[ $e =~ ([^\\]|^)(\\[*?]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"} ;done 
IFS=$'\015';set -- $e
[[ $1 =~ ^((.*/)?([^/]+))?(/*)$ ]]
z=${BASH_REMATCH[4]}
a=\"${BASH_REMATCH[3]}\"$z
L=$a\ ${@:2}		# L Loop
unset p n P R Z
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
elif [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
	s=~+/${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}	# p is first explicit path
	while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
	[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom ~+/$a>&2;continue;}
	s=${s%/}
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
		a=$s$p
	else
		a=$s$p
		while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
	fi
else
	s=~+;[ "$a" ] &&{
	p=/$a
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
		a=$s$p
	else
		a=$s$p
		while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
	fi
	}
fi
a=${a%/}

b=${a%/*}
eval set -- $L
for f
{
[[ $f =~ ^(.*[^/])?(/*)$ ]]
f=${BASH_REMATCH[1]}
f=$b${f:+/$f}
z=${BASH_REMATCH[2]}
if [[ $z = / ]] ;then Z="-type d \( -path '* *' -printf \"'$ft/'\n\" -o -printf \"$ft/\n\" \)"
elif [[ $z = // ]] ;then Z="-type f \( -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \)"
elif [[ $z = /// ]] ;then Z="-executable \( -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \)"
elif [[ $z = //// ]] ;then Z="-type l \( -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \)"
else	Z="\( -type d \( -path '* *' -printf \"'$ft/'\n\" -o -printf \"$ft/\n\" \) -o \( -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \) \)"
fi
if [ $E ] ;then
	R=\"${f//\\/\\\\}\"
	((re))&&R=.*$R
elif [[ $f =~ ([^\\]|^)[*?] ]] ;then
	if [[ $f =~ /.*[^/]*\*\*[^/]*$ ]] ;then
		p=${BASH_REMATCH[0]}
		[[ $p =~ \.\*$ ]] && p=${p/BASH_REMATCH[0]/\\\\.[^/]+}
		n=
	elif [[ $f =~ ^(.*/)?(.+)$ ]] ;then
		p=${BASH_REMATCH[1]%/}
		n=/${BASH_REMATCH[2]}
	fi
	if((re)) ;then
		p=**${p#$s}
	else
		[[ $p =~ ^((/[^/*?]*)*)(/.*)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
	fi
	if [[ $n =~ ^/\*(\.\*)?$|^/\.\*$ ]] ;then
		n=${n//\*/[^/]+}
	else
		p=$p$n
		n=
	fi
	while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
	while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	while [[ $p =~ ([^\]\\*])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
	p=${p//\*\*/.*}
	R=\".{${#s}}$p$n\"
	: ${s:=/}
elif((re)) ;then
	if [ "$f" ]	;then
		f=${f#$s}
		while [[ $f =~ ([^\\]|^)([{}().]) ]] ;do f=${f/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
		R="\".{${#s}}$f\" \( -type d -exec find '{}' $d $opt $XC $Z \; -o -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \) -o -${I}path \"$s/*$f\" \( -path '* *' -printf \"'$ft'\n\" -o -printf \"$ft\n\" \)"
		Z=
	else	R=.*
	fi
elif [ -d "$f" ] ;then	s=$f;R=.*
else	s=${f%/*};R=".* -${I}path \"$f\""
fi
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
unset IFS a po opt se E sz t Fx XC dt l lh lx cp cpe re i j if;de=0 ;I=i
set -f;trap 'set +f;unset IFS' 1 2
for e;{
case $e in
-[HDLPO]) po=$e;;
-h|--help) find --help | sed -E "1,3s/find/$FUNCNAME/";return;;
-cp=?*|-cpu=?*) C=1;;
-ex=?*|-exc=?*) Fx=1;;
-[1-9]|-[1-9][0-9]) dt=-maxdepth\ ${e:1};;
-[1-9]-*|[1-9][0-9]-*)
	dt=${e#-}
	z=${dt#*-}
	dt="-mindepth ${dt%-*}${z:+ -maxdepth $z}";;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring;;
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
-[ac-il-x]) echo \'$e\' : inadequate more specific option, ignoring;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unknown option, ignoring. If it\'s meant a path name, put it after - or -- and space;;
*) break;;
esac
}
shopt -s extglob
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
c=${BASH_REMATCH[1]}
while [[ $c =~ ([^\\])[\;|\>\<] ]] ;do c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done
IFS=$'\n';set -- $c
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{ a=${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]};break;};}
a=${a//\\/\\\\}
unset IFS;eval set -- ${a:-\"\"}
for a;{
case $a in
	-ex=?*|-exc=?*)
		[[ $a =~ ^-exc?=(.+)$ ]]
		shift;c=("$@")			# Preserve array to c
		eval set -- ${BASH_REMATCH[1]}
		fx "$@"
		I=i;eval set -- "${c[@]}";;
	-cp=?*|-cpu=?*)
		
		;;
	-[!-]*)	shift;;
	-|--)	shift;break;;
	*)	break;;
esac
(($1)) || set -- ''
}
P="\( -path '* *' -printf \"$sz$t'%p'\n\" -o -printf \"$sz$t%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$sz$t'%p/'\n\" -o -printf \"$sz$t%p/\n\" \)"
((l)) &&{
 [ -z $lx ]&&lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
for e;{
unset b B LO M s
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
: ${se='\\\\'} # Get multi items separated by \\ or else, in same dir, if any, and none has exact .. pattern
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
while [[ $e =~ ([^\\]|^)(\\[^\\]|\\$) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"} ;done 

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
unset IFS
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
d=${p%/*};
IFS=$'\n';eval set -- ${p##*/}$z$M; r=("$@")
#echo ${r[@]};return
p=$p$M
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\]\\*])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
p=${p//\*\*/.*}
M=${M:+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}${z//\//$'\v'}$M
b=${b%$'\v'*}
i=;eval set -- ${p:-\"\"}
for f;{
unset z Z F;R=.*
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
	elif((re)) ;then	F=1;opt=
	else
		s=$s$f
		[ ! -d "$s" ] && R="\"$s\"";s=\"${s%/*}\"
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
R="\".{${#s}}$f\" \( -type d -exec find '{}' $dt $opt $Z \; -o $P \)"${f:+" -o -${I}regex \".{${#s}}.+$f\" \( $PD -o $P \)"}
Z=
}
LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	export -f fd
	eval "find $po \"$s\" -regextype posix-extended $dt \! -iregex \"${XC-$s}\" $opt -${I}regex $R $P ! -type d -executable -exec /bin/bash -c 'fd \"\$0\" \"\$@\"' '{}' \;"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$s\" -regextype posix-extended $dt \! -iregex \"${XC-$s}\" $opt -${I}regex $R $P ! -type d -exec /bin/bash -c '
		[[ \`file \"{}\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]];echo \  \${BASH_REMATCH[1]}' \;"
#elif [ $cp ] ;then
	#mkdir -pv $cp
	#eval "find $po $s $dt \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -ft '{}' ${cp[0]}/\{\} \;"
#elif [ $cpu ] ;then
	#mkdir -pv $cpu
	#eval "find $po $s $dt \! -ipath $s $P $opt $XC -exec cp -ft '{}' $cpu \;"
else
	#command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) 
	eval "find $po \"$s\" -regextype posix-extended $dt $opt -${I}regex $R \! -${I}regex \"${XC-$s}\" $Z"
fi
((i++));}
}
}
set +f;unset IFS
}

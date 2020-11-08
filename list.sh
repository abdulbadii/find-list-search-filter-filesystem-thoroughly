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
	echo -e "$i\n ${BASH_REMATCH[1]}\n DEPs"
	ldd "$i" 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/  \2/'
}
}
l(){
unset IFS a po opt se E s t Fx XC d l lh lx cp cpe re i j if;de=0 ;I=i
set -f;trap 'set +f;unset IFS' 1 2
for e;{
case $e in
-[HDLPO]) po=$e;;
-h|--help) find --help | sed -E "1,3s/find/$FUNCNAME/";return;;
-cp=?*|-cpu=?*) C=1;;
-ex=?*|-exc=?*) Fx=1;;
-[1-9]|-[1-9][0-9]) d=-maxdepth\ ${e:1};;
-[1-9]-*|[1-9][0-9]-*)
	d=${e#-}
	z=${d#*-}
	d="-mindepth ${d%-*}${z:+ -maxdepth $z}";;
-sep=?|-sep=??) se=${e:5};;
-sep=*) echo Separator must be 1 or 2 characters, ignoring.;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]|-l[1-9][0-9])
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-E|-re) E=1;;
-s)	s=%s\ ;;
-t)	t="%Tr %Tx ";;
-[ac-il-x]) echo \'$e\' : inadequate more specific sub-option, ignoring;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unknown option, ignoring. If it\'s meant a path name, put it after - or -- and space;;
*) break;;
esac
}
shopt -s extglob
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
c=${BASH_REMATCH[1]}
while [[ $c =~ ([^\\])[\;|\>\<] ]] ;do c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\013'} ;done
IFS=$'\013'
set -- $c
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{ a=${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]};break;}
}
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
	-[!-]*)
		shift;;
	-|--)
		shift;break;;
	*)
		break;;
esac
}
P="\( -path '* *' -printf \"$s$t'%p'\n\" -o -printf \"$s$t%p\n\" \)"
PD="-type d \( -path '* *' -printf \"$s$t'%p/'\n\" -o -printf \"$s$t%p/\n\" \)"

((l)) &&{
 [ -z $lx ]&&lh=-prune; PD="-type d $lh -exec find \{\} $lx $opt \( $PD -o $P \) \;"
}
for e;{
unset b B LO L M s z
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
# Get multiple items separated by \\ or else, in same dir. only if any, and none has exact .. pattern
: ${se='\\'}
while [[ $e =~ ([^\\])($se) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\n'} ;done 
while [[ $e =~ ([^\\]|^)(\\[^\\]|\\$) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"} ;done 

IFS=$'\n';set -- $e
#get any common dir. path (B) if any
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
B=${BASH_REMATCH[2]}
z=${BASH_REMATCH[5]}
LO=\"${BASH_REMATCH[4]}\"
while [[ ${BASH_REMATCH[4]} =~ (^|/)..$ ]] ;do B=$B../;LO=*$z;done
F=1
shift;for a;{
	[[ $a =~ (/|^)\.\.(/|$) ]] &&{	LO=$LO\ $@;F=;break;}
}
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
	p=${a:+/$a}
	s=~+
	if((re)) ;then
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
	else
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		while [[ $p =~ ^/..(/|$) ]];do p=${p#/..}; s=${s%/*} ;done
		[[ -z "$s" ]] &&{ echo Invalid path: $a. It goes up beyond root >&2;continue;}
	fi
fi
p=${p%/}$M
eval set -- $p; r=("$@")
#if((E)) ;then
	#R="${p//\\/\\\\}"
	#((re))&&R=.*$R
#fi
p=${p//\//$'\v'}
while [[ $p =~ ([^\\]\[)! ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}^"} ;done
while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
while [[ $p =~ ([^\]\\*])\*([^*]|$) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]*${BASH_REMATCH[2]}"} ;done
p=${p//\*\*/.*}

M=${M+$'\n'${p#*$'\n'}}
b=${p%%$'\n'*}
p=${b##*$'\v'}
b=${b%$'\v'*}
p=$p$z$M
i=0;IFS=$'\n';eval set -- ${p:-\"\"}
for f;{
unset n R
[[ $f =~ ^(.*[^/])?(/*)$ ]]
case ${BASH_REMATCH[2]} in
/)	Z="$PD";;
//)	Z="-type f $P";;
///)	Z="-executable $P";;
////)	Z="-type l $P";;
*)	Z="\( $PD -o $P \)";;
esac
f=${BASH_REMATCH[1]}
if [ "$f" ] ;then
	if [[ $f =~ ([^\\]|^)[[*?] ]] ;then
		f=$b$'\v'$f
		if((re)) ;then	p=.*$f
		else
			[[ $f =~ ^([^[*?]*)($'\v'.+)$ ]]
			s=$s${BASH_REMATCH[1]}
			p=${BASH_REMATCH[2]}
		fi
		while [[ $p =~ ([^\\]|^)([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
		R=\".{${#s}}${p//$'\v'/\/}\"
	elif((re)) ;then
		f=${r[$i]}
		R="\".{${#s}}$f\" \( -type d -exec find '{}' $d $opt ${XC=$s} $Z \; -o -path '* *' -printf \"$fq\n\" -o -printf \"$ft\n\" \) -o -${I}path \"$s/*$f\" \( -path '* *' -printf \"$fq\n\" -o -printf \"$ft\n\" \)"
		Z=
	else
		f=${r[$i]}
		if [ -d "$f" ] ;then	s=$f;R=.*
		else	s=${f%/*};R="\"$f\""
		fi
	fi
	: ${s:=/}
else
	R=.*
fi
LC_ALL=C
if((de)) &&[[ $z != / ]] ;then
	export -f fd
	eval "find $po \"$s\" -regextype posix-extended $d \! -iregex \"${XC-$s}\" -${I}regex $R $opt \( -executable -exec /bin/bash -c 'fd \"\$0\" \"\$@\"' '{}' + -o $P \)"
elif((if)) &&[[ $z != / ]] ;then
	eval "find $po \"$s\" -regextype posix-extended $d \! -iregex \"${XC-$s}\" -${I}regex $R $opt \( ! -type d -exec /bin/bash -c 'for i;{
		[[ \`file \"\$i\"\` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]]
		echo \"\$i\";echo \  \${BASH_REMATCH[1]}
	}' dm '{}' + \)"
#elif [ $cp ] ;then
	#mkdir -pv $cp
	#eval "find $po $s $d \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -ft '{}' ${cp[0]}/\{\} \;"
#elif [ $cpu ] ;then
	#mkdir -pv $cpu
	#eval "find $po $s $d \! -ipath $s $P $opt $XC -exec cp -ft '{}' $cpu \;"
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) eval "find $po \"$s\" -regextype posix-extended $d \! -iregex \"${XC-$s}\" -${I}regex $R $opt $Z"
fi
((i++));}
}
}
set +f;unset IFS
}

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
[[ $1 =~ ^(.*[^/])?(/*)$ ]]
z=${BASH_REMATCH[2]}
[[ ${BASH_REMATCH[1]} =~ ^(/?([^/]+/)*)([^/]+)$ ]] 
a=\"${BASH_REMATCH[3]}\"$z
L=$a\ ${@:2}		# L Loop
unset p n P R Z
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
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
fi
a=${a%/}

b=${a%/*}
eval set -- ${L-\"\"}
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
	[[ $f =~ ^((/[^/*?]+)*)(/.+)?$ ]]
	R="^${BASH_REMATCH[1]}${BASH_REMATCH[3]}$"
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

di(){
d=$1;shift
for l
{
	[[ `file $l` =~ ^[^:]+:[[:space:]]*([^,]+$|[^,]+[[:space:]]([^,]+)) ]]
	echo -e $l\\n${BASH_REMATCH[1]}
	(($d)) &&	[[ ${BASH_REMATCH[2]} =~ ^execut ]] &&{
		ldd $l 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/ \2/;s/^.*\blinux-vdso\.s.+/DEP:/';}
}
}
l(){
unset IFS a o po opt se de if E s Fx XC d l lh lx cp cpe re ;I=i;ft=%p
LC_ALL=C;set -f
trap 'set +f;unset IFS' 1 2
for e
{
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
-sep=*) echo Separator must be 1 or 2 characters;;
-de) de=1;;
-in) if=1;;
-cs) I=;;
-ci) I=i;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]|-l[1-9][0-9])
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-E) E=1;;
-s) ft=%s\ $ft;;
-t) ft="$ft %Tr %Tx";;
-st) ft='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate more specific sub-option, ignoring;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a path name, put it after - or -- and space;;
*) break;;
esac
[[ $e =~ ^-exc?=|^cpu?= ]] || o=$o\ $e
}

((l)) &&{
 [ -z $lx ] &&lh=-prune
 D="-type d $lh -exec find \{\} $lx $opt \( $D -o -printf \"$ft\n\" \) \;"
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
c=${BASH_REMATCH[1]}
while [[ $c =~ ([^\\])[\;|\>\<] ]] ;do c=${c/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\013'} ;done
IFS=$'\013'
set -- $c
for e;{
	[[ $e =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{ a=${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]};break;}
}
shopt -s extglob
a=\ ${a//  / };a=${a//   / };a=${a#$o};a=${a##+( )}

unset IFS;eval set -- ${a:-\"\"}
if [[ $a =~ ^--?$ ]] ;then shift
else
((Fx+C))&&{
	for a;{
		if [[ $a =~ ^-exc?=(.+)$ ]];then
			eval set -- ${BASH_REMATCH[1]}
			for e;{
				fx $e
				XC=$XC$xc' ';}
			a=${a#${BASH_REMATCH[0]}}
			I=i
		#elif [[ $a =~ ^-cpu?=(.+)$ ]];then
			
			#a=${a#${BASH_REMATCH[0]}}
		fi
	}
}
fi
for e
{
unset b B In LO L z
[[ ${e:0:2} = \\ ]] &&{	z=${e##+(\\)};z=${z#/}; e=/;}
[[ $e =~ ^\.?/[^/] ]]||re=1	# if no prefix ./ nor / is the first, it's recursive at any depth of PWD
e=${e#./}
# Get multiple items separated by \\ or -sep, in same dir. only if any, and none has exact .. pattern
: ${se='\\'}
while [[ $e =~ ([^\\])($se)([^\\]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\015'"${BASH_REMATCH[3]}"} ;done 
while [[ $e =~ ([^\\]|^)(\\[*?]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}"} ;done 
IFS=$'\015';set -- $e
#get any common dir. path (B) if any, to join with PWD
[[ $1 =~ ^((/?([^/]+/)*)([^/]+))?(/*)$ ]]
z=${BASH_REMATCH[5]}
B=${BASH_REMATCH[2]}
LO=\"${BASH_REMATCH[4]}\"$z		# LO Loop of outer part
[[ ${BASH_REMATCH[4]} = .. ]] &&{	B=$B../;LO=*$z; L=*$z ;}
if [ $# = 1 ];then L=$LO
else
	L=$LO\ ${@:2}		# L Loop inner part
	shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{ z=$L;L=$LO; LO=$z; break;};}
fi
unset IFS; eval set -- ${LO:-\"\"}
for a;{
a=$B${a%%+(/)}
unset p n P R Z
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
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
fi
a=${a%/}

b=${a%/*}
eval set -- ${L-\"\"}
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
	[[ $f =~ ^((/[^/*?]+)*)(/.+)?$ ]]
	R="^${BASH_REMATCH[1]}${BASH_REMATCH[3]}$"
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
if((de+if)) &&[ $F$LN ] ;then
	export -f di
	eval "find $po $s $d \! -ipath $s $XC $R $opt $X \( \( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o $D -o -printf \"$ft\n\" \)"

#elif [ $cp ] ;then
	#mkdir -pv $cp
	#eval "find $po $s $d \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -ft '{}' ${cp[0]}/\{\} \;"
#elif [ $cpu ] ;then
	#mkdir -pv $cpu
	#eval "find $po $s $d \! -ipath $s $P $opt $XC -exec cp -ft '{}' $cpu \;"
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) eval "find $po \"$s\" -regextype posix-extended $d \! -ipath \"${XC-$s}\" -${I}regex $R $opt $XC $Z"
fi
}
}
}
set +f;unset IFS
}

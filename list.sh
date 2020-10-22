fc(){
local unset O P re p n s z Z
[[ $1 =~ ^\./ ]] || re=.*
a=${1#./}
[[ $a =~ ^(.*[^/])?(/+)$ ]] &&{ # Get /, // as dir, file filtered search 
	a=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	[[ $a = \\ ]] &&{	a=/;	z=${z#/}; }
}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual exclusion path: $a >&2;continue;}
	a=${a%/}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		s=~+/${BASH_REMATCH[1]}
		fx=${BASH_REMATCH[3]}	# fx is first explicit path
		while [[ $s =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
		[[ $s =~ ^/..(/|$) ]] &&{ echo Invalid actual exclusion path: $s >&2;continue;}
		s=${s%/}
		while [[ $fx =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do fx=${fx/"${BASH_REMATCH[0]}"/\/};done
		if [ $re ] ;then
			[[ $fx =~ ^(/\.\.)+(/|$) ]] && fx=${fx/${BASH_REMATCH[0]}}
			a=$s**${fx:+/$fx}
		else
			a=$s$fx
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		s=~+
		if [ $re ] ;then
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^(/\.\.)+(/|$) ]] && a=${a/${BASH_REMATCH[0]}}
			a=$s**${a:+/$a}
		else
			a=$s${a:+/$a}
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
D="-type d"
F="-type f"
K="-type l"
if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$K
fi
if [ $E ] ;then
	X="\! -${2}regex ^$a$ $Z"
elif [[ $a =~ [*?] ]] ;then
	while [[ $a =~ ([^\\])([]\[{}().]) ]] ;do a=${a/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}} ;done
	[[ $a =~ ^(/.*\*\*)([^/]*)$ ]] || [[ $a =~ ^(/.+)(/[^/]*)$ ]]
	p=${BASH_REMATCH[1]//\*\*/~\}\{}
	n=${BASH_REMATCH[2]}
	if [[ $n =~ ^/(\*)(\.\*)?$ ]] ;then
		if [ ${BASH_REMATCH[2]} ] ;then
			n=/[^/.][^/]*\\.[^/]+
		else
			n='/[^/.][^/]*\(\\.[^/]+\)?'
		fi
	elif	[[ $n =~ ^\.\*$ ]] ;then n=\\.[^/]+
	else
		n=${n//\?/[^/]}
		n=${n//\*/[^/]*}		
	fi
	p=${p//\*/[^/]*}
	p=${p//~\}\{/.*}
	p=${p//\?/[^/]}
	X="! -${2}regex ^$p$n$"
else
	if [ -d "$a" ] ;then
		X="$a -prune" #${2}path $a/*"
	else
		X="! -${2}path $a"
	fi
fi
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
unset IFS a o po opt se de if E s X XC d l lx cp cpe
I=i;r=%p
set -f;trap 'set +f;unset IFS' 1 2
for e
{
case $e in
-[HDLPO]) po=$e;;
-h|--help) find --help | sed -E "1,3s/find/$FUNCNAME/";return;;
-cp=?*|-cpe=?*)
	[[ `history 1` =~ ^\ *[0-9]+\ +.+\ \$\(\ *$FUNCNAME\ +(.*)\) ]] || [[ `history 1` =~ ^\ *[0-9]+\ +.+\ \`\ *$FUNCNAME\ +(.*)\` ]] || [[ `history 1` =~ ^\ *[0-9]+\ +.*$FUNCNAME\ +(.*) ]] &&\
	IFS=$';';eval set -- ${BASH_REMATCH[1]}

	[[ $1 =~ (-[[:alnum:]]+(=.+)?\ +)*(--?\ )?(.*) ]]
	eval set -- ${BASH_REMATCH[4]}
	for c;{
		[[ $c =~ ^-cpe?=(.+) ]] &&{
			eval set -- ${BASH_REMATCH[1]}
			e=${e%%=*};	eval ${e#-}=\$@
			break
		}
	};;
-ex=?*|-exc=?*)
	[[ `history 1` =~ ^\ *[0-9]+\ +.+\ \$\(\ *$FUNCNAME\ +(.*)\) ]] || [[ `history 1` =~ ^\ *[0-9]+\ +.+\ \`\ *$FUNCNAME\ +(.*)\` ]] || [[ `history 1` =~ ^\ *[0-9]+\ +.*$FUNCNAME\ +(.*) ]] &&\
	IFS=$';';eval set -- ${BASH_REMATCH[1]}

	[[ $1 =~ (-[[:alnum:]]+(=.+)?\ +)*-exc?=(.+)$ ]]
	eval set -- ${BASH_REMATCH[3]}
	eval set -- $1
	for x;{
		fc $x $I
		XC=$XC$X' '
	}
	I=i;;
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
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate more specific sub-option, ignoring;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a full path name, put it after - or --;;
*) break;;
esac
o=\ $o$e
}

[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=\;
set -- ${BASH_REMATCH[1]}
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{ a=${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]};break;}
}
shopt -s extglob
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
LN="-type l -printf \"$r\n\""
a=\ ${a//  / };a=${a//   / }
a=${a#$o}
a=${a##+( )}
# if no prefix ./ it's recursively at any depth of PWD
[[ $a =~ ^\./ ]];re=$?
a=${a#./}
a=${a//\\/\\\\}
unset IFS;eval set -- ${a:-\"\"}
for e
{
unset B In LO L z
# Get suffix /, // for dir, file search filter
[[ ${e:0:2} = \\\\ ]] &&{	z=${##*/}; e=/ ;}

# Get multiple items separated by \\ or -sep, in same dir. only if any, and if none has ** or exact .. pattern
if [ $e ] ;then
	: ${se='\\\\'}
	while [[ $e =~ ([^\\])($se)([^\\]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"$'\037'"${BASH_REMATCH[3]}"} ;done 
	while [[ $e =~ ([^\\]|^)(\\[*?]) ]] ;do e=${e/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}\\\\\\${BASH_REMATCH[2]}"} ;done 
	IFS=$'\037';set -- $e
	[[ $1 =~ ^(.+/)?([^/]+/*)$ ]] #if any explicit dir. path, get it (B) to join with PWD, else just PWD
	B=${BASH_REMATCH[1]}
	LO=${BASH_REMATCH[2]}
	L="$LO ${@:2}"
	if [ $# = 1 ] ;then	L=
	else
		[[ $fs =~ ^\.\.$ ]] &&{ LO=$L; L=; break;}
		shift;for a;{	[[ $a =~ (/|^)\.\.(/|$) ]] &&{ LO=$L; L=; break;};}
	fi
else	LO=\"\"
fi
unset IFS; eval set -- $LO
for a;{
[[ $a =~ ^(.*[^/])(/*)$ ]]
z=${BASH_REMATCH[2]}
a=$B${BASH_REMATCH[1]}
[ -z $a ] &&{
	((re))||d="-maxdepth 1"; eval "LC_ALL=C find $po ~+ $d \! -ipath ~+ $opt $XC $Z" ;continue;}
unset p n P Z
if [[ $a =~ ^/ ]] ;then re=
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		s=~+/${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}	# p is first explicit path
		while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
		[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom ~+/$a>&2;continue;}
		s=${s%/}
		while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
		if((re)) ;then
			[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}} # clear remaining leading /..
			a=$s$p
		else
			a=$s$p
			while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		s=~+;	p=${a:+/$a}
		if((re)) ;then
			while [[ $p =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do p=${p/"${BASH_REMATCH[0]}"/\/};done
			[[ $p =~ ^((/\.\.)+)(/|$) ]] && p=${p/${BASH_REMATCH[1]}}
			a=$s$p
		else
			a=$s$p
			while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
a=${a%/}

((l)) &&{ [ -z $lx ] &&l=-prune;D="-type d $l -exec find \{\} $lx $opt \( $D -o -printf \"$r\n\" \) \;"
}

b=${a%/*}/
eval set -- ${L:-${a##*/}}
for f
{
f=$b$f
[ "$L" ]&&{ [[ $f =~ ^(.*[^/])(/*)$ ]];f=${BASH_REMATCH[1]};z=${BASH_REMATCH[2]};}
if [ $E ] ;then
	[[ $f =~ ^((/[^/*?]+)*)(/.+)?$ ]]
	P="-regextype posix-extended -${I}regex ^${BASH_REMATCH[1]}${BASH_REMATCH[3]}$"
elif [[ $f =~ ([^\\]|^)[*?] ]] ;then
	if [[ $f =~ (/.*[^/]*\*\*[^/]*)$ ]] ;then
		p=${BASH_REMATCH[1]}
		[[ $p =~ \.\*$ ]] && p=${p/BASH_REMATCH[0]/\\\\.[^/]+}
		n=
	elif [[ $f =~ ^(.*/)?(.+)$ ]] ;then
		p=${BASH_REMATCH[1]}
		: ${p:=/}
		n=${BASH_REMATCH[2]}
	fi
	if((re)) ;then
		p=**${p#$s}
	else
		[[ $p =~ ^((/[^/*?]*)*)(/.*)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
	fi
	if [[ $n =~ ^/(\*)(\.\*)?$ ]] ;then
		if [ ${BASH_REMATCH[2]} ] ;then
			n=/[^/.][^/]*\\\\.[^/]+
		else
			n='/[^/.][^/]*\(\\\\.[^/]+\)?'
		fi
	elif	[[ $n =~ ^\.\*$ ]] ;then n=/\\\\.[^/]+
	else
		p=$p$n
		n=
	fi
	while [[ $p =~ ([^\\])\? ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]"} ;done
	while [[ $p =~ ([^\\])([{}().]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	while [[ $p =~ ([^\\*])\*([^*]) ]] ;do p=${p/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}[^/]\*${BASH_REMATCH[2]}"} ;done
	p=${p//\*\*/.*}
	P="-regextype posix-extended -${I}regex ^$s$p$n$"
else
	if((re)) ;then
		P="-${I}path $f \( -type d -exec find '{}' $Z \; -o -print \) -o -${I}path $s/*${f#$s} -printf \"$r\n\""
	elif [ -d "$f" ] ;then
		s=$f
	else
		s=${f%/*}
		P="-${I}path $f"
	fi
fi
if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$LN
else	Z="\( $D -o -printf \"$r\n\" \)"
fi

if((de+if)) &&[ $F$LN ] ;then
	export -f di
	F="$F ${LN+-o $LN}"
	eval "LC_ALL=C find $po $s $d \! -ipath $s $XC $P $opt $X \( \( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o $D -o -printf \"$r\n\" \)"

#elif [ $cp ] ;then
	#mkdir -pv $cp
	#eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -r '{}' ${cp[0]}/\{\} \;"
#elif [ $cpe ] ;then
	#mkdir -pv $cpe
	#eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC -exec cp -r '{}' $cpe \;"
	
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC $Z"
fi
}
}
}
set +f;unset IFS
}

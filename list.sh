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
unset IFS o po opt de if E s X XC d l lx cp cpe
I=i; r=%p
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
o=$o$e' '
}
[[ `history 1` =~ ^\ *[0-9]+\ +(.+)$ ]]
IFS=\;;set -- ${BASH_REMATCH[1]}
for c;{
	[[ $c =~ ^.+\ *\$\(\ *$FUNCNAME\ +(.*)\)|.+\ *\`\ *$FUNCNAME\ +(.*)\`|\ *$FUNCNAME\ +(.*) ]]&&{ a=${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]};break;}
}
a=${a//  / };a=${a//   / };a=${a#$o}
set -- ${a:-\'\'}
for e
{
unset A B Fl z as
[[ $e =~ ^\./ ]] ;re=$? # it's recursively at any depth of PWD if no prefix ./
e=${e#./}

[[ $e =~ ^(.*[^/])?(/+)$ ]] &&{ # Get /, // as dir, file filtered search 
	e=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	[[ $e =~ ^\\\\? ]] &&{	e=/;	z=${z#/}; }
}
e=${e//\/.\///}
IFS=$'\\';set -- ${e:-\'\'}
# Get multiple items separated by \\ in same dir. only if any, and if none has ** or exact .. pattern in the last / (file name)
if [ "$#" = 1 ] ;then	Fl=1
else for a;{	[[ $a =~ (^|/)(\.\.|.*\*\*.*)$ ]] &&{ Fl=1;break;};}
fi

if [[ $1 =~ / ]] ;then
	A=${1##*/}
	B=${1%/*}/
else
	A=$1
fi
S="$A ${@:2}"
unset IFS
if(($Fl));then	set -- $S
else	set -- $A
fi
for a;{
unset p n P Z
a=$B$a
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
LN="-type l -printf \"$r\n\""
if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$LN
else	Z="\( $D -o -printf \"$r\n\" \)"
fi
#echo -e '\e[41;1;37m' #a=${a//\\/\\\\}
if [[ $a =~ ^/ ]] ;then re=
	while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		a=${a%/}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		s=~+/${BASH_REMATCH[1]}
		f=${BASH_REMATCH[3]}	# f is first explicit path
		while [[ $s =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
		[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom ~+/$a>&2;continue;}
		s=${s%/}
		while [[ $f =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do f=${f/"${BASH_REMATCH[0]}"/\/};done
		if((re)) ;then
			[[ $f =~ ^((/\.\.)+)(/|$) ]] && f=${f/${BASH_REMATCH[1]}} # clear remaining leading /..
			a=$s**$f
		else
			a=$s$f
			while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		s=~+;	a=${a:+/$a}
		if((re)) ;then
			while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^(/\.\.)+(/|$) ]] && a=${a/${BASH_REMATCH[0]}}
			a=$s**$a
		else
			a=$s$a
			while [[ $a =~ /([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
	a=${a%/}
fi
((l)) &&{ [ -z $lx ] &&l=-prune
	D="-type d $l -exec find \{\} $lx $opt \( $D -o -printf \"$r\n\" \) \;"
}
b=${a%/*}/
Fl=$Fl
if(($Fl)) ;then
	set -- $A
else
	set -- $S;
fi
for f
{
f=$b$f
if [ $E ] ;then
	[[ $f =~ ^((/[^/*?]+)*)(/.+)?$ ]]
	s=${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}
	P="-regextype posix-extended -${I}regex ^$s$p$"
elif [[ $f =~ [*?] ]] ;then
	while [[ $f =~ ([^\\])([{}().]) ]] ;do f=${f/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\\\${BASH_REMATCH[2]}} ;done
	[[ $f =~ ^(/.*\*\*)([^/]*)$ ]] || [[ $f =~ ^(/.+)(/[^/]*)$ ]]
	p=${BASH_REMATCH[1]}
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
	
	if((re)) ;then
		p=${p#$s}
	else
		[[ $p =~ ^((/[^/*?]*)*)(/.*)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
	fi	
	p=${p//\*\*/~\}\{}
	p=${p//\*/[^/]*}
	p=${p//~\}\{/.*}
	p=${p//\?/[^/]}
	P="-regextype posix-extended -${I}regex ^$s$p$n$"
else
	if((re)) ;then
		P="-${I}path $f \( -type d -exec find '{}' $Z \; -o -print \) -o -${I}path $s*/${f#$s} -printf \"$r\n\""
	elif [ -d "$f" ] ;then
		s=$f
	else
		s=${f%/*}
		P="-${I}path $f"
	fi
fi

if((de+if)) &&[ $F$LN ] ;then
	export -f di
	F="$F ${LN+-o $LN}"
	eval "LC_ALL=C find $po $s $d \! -ipath $s $XC $P $opt $X \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o} $D -o -printf \"$r\n\" \)"

elif [ $cp ] ;then
	mkdir -pv $cp
	
	eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -r '{}' ${cp[0]}/\{\} \;"

elif [ $cpe ] ;then
	mkdir -pv $cpe
	eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC -exec cp -r '{}' $cpe \;"
	
else
	command 2> >(while read s;do echo -e "\e[1;31m$s\e[m" >&2; done) eval "LC_ALL=C find $po $s $d \! -ipath $s $P $opt $XC $Z"
fi
}
}
}
set +f;unset IFS
}

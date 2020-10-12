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
a=${a//\\/\\\\}
set -- ${a:-\'\'}
for e
{
unset Fl z as S
[[ $e =~ ^\./ ]] ;re=$? # it's recursively at any depth if no prefix ./
e=${e#./}

[[ $e =~ ^(.*[^/])?(/+)$ ]] &&{ # Get /, // as dir, file filtered search 
	e=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	[[ $e = \\ ]] &&{	e=/;	z=${z#/}; }
}
e=${e//\/.\///}
IFS=$'\\';eval set -- ${e:-\'\'} # Get multiple items for the same dir. path separated by \\
[[ $e =~ (^|\ |/)\.\.(/|\ |$)|\*\* ]] || S="${@:2}"
B=${1%/*}/

for a;{
unset p n P Z
if((Fl)) ;then
	a=$B$a
else
	Fl=1
fi
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
LN="-type l -printf \"$r\n\""

if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$LN
else	Z="\( $D -o -printf \"$r\n\" \)"
fi
if [[ $a =~ ^/ ]] ;then re=
	while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		a=${a%/}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		s=~+/${BASH_REMATCH[1]}
		fx=${BASH_REMATCH[3]}	# fx is first explicit path
		while [[ $s =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do s=${s/"${BASH_REMATCH[0]}"/\/};done
		[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom ~+/$a>&2;continue;}
		s=${s%/}
		while [[ $fx =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do fx=${fx/"${BASH_REMATCH[0]}"/\/};done
		if(($re)) ;then
			[[ $fx =~ ^(/\.\.)+(/|$) ]] && fx=${fx/${BASH_REMATCH[0]}}
			[[ $fx =~ ^[^*?]+$ ]] &&{
				P="-${I}path $s$fx \( -type d -exec find '{}' $Z \; -o -printf \"$r\n\" \) -o -${I}path $s*$fx -printf \"$r\n\""
			}
			a=$s**${fx:+/$fx}
		else
			a=$s$fx
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		s=~+
		if(($re)) ;then
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^(/\.\.)+(/|$) ]] && a=${a/${BASH_REMATCH[0]}}
			[[ $a =~ ^[^*?]+$ ]] &&
				P="-${I}path $s/$a \( -type d -exec find '{}' $Z \; -o -print \) -o -${I}path $s*/$a -printf \"$r\n\""
			a=$s**${a:+/$a}
		else
			a=$s${a:+/$a}
			while [[ $a =~ (/|^)([^.].|.[^.]|[^/]{3,}|[^/])/\.\.(/|$) ]];do a=${a/"${BASH_REMATCH[0]}"/\/};done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
((l)) &&{
	[ -z $lx ] &&l=-prune
	D="-type d $l -exec find \{\} $lx $opt \( $D -o -printf \"$r\n\" \) \;"
}

[ $S ] &&{	b=${a%/*};unset IFS; set -- $S
	for o ;{ as=$as\ $b/$o;}
}
for A in $a $as
{
if [ -z "$P" ] ;then
	if [ $E ] ;then
		[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
		P="-regextype posix-extended -${I}regex ^$s$p$"
	else
		if [[ $a =~ [*?] ]] ;then
			while [[ $a =~ ([^\\])([]\[{}().]) ]] ;do a=${a/"${BASH_REMATCH[0]}"/${BASH_REMATCH[1]}\\${BASH_REMATCH[2]}} ;done
			[[ $a =~ ^(/.*\*\*)([^/]*)$ ]] || [[ $a =~ ^(/.+)(/[^/]*)$ ]]
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
				p=.*
			else 
				[[ $p =~ ^((/[^/*?]*)*)(/.*)?$ ]]
				s=${BASH_REMATCH[1]}
				p=${BASH_REMATCH[3]//\*\*/~\}\{}
				p=${p//\*/[^/]*}
				p=${p//~\}\{/.*}
				p=${p//\?/[^/]}
			fi
			P="-regextype posix-extended -${I}regex ^$s$p$n$"
		else
			if [ -d "$a" ] ;then
				s=$a
			else
				s=${a%/*}
				P="-${I}path $a"
			fi
		fi
	fi
fi
if((de+if)) &&[ $F$LN ] ;then
	export -f di
	F="$F ${LN+-o $LN}"
	eval "LC_ALL=C find $po $s $d \! -ipath $s $XC $P $opt $X \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o} $D -o -printf \"$r\n\" \)"

elif [ $cp ] ;then
	sudo mkdir -pv $cp
	
	eval "LC_ALL=C sudo find $po $s $d \! -ipath $s $P $opt $XC -exec mkdir -p ${cp[0]}/\{\} &>/dev/null \; -exec cp -r '{}' ${cp[0]}/\{\} \;"

elif [ $cpe ] ;then
	sudo mkdir -pv $cpe
	eval "LC_ALL=C sudo find $po $s $d \! -ipath $s $P $opt $XC -exec cp -r '{}' $cpe \;"
	
else
	command 2> >(while read s;do echo -e "\e[01;31m$s\e[m" >&2; done) eval "LC_ALL=C sudo find $po $s $d \! -ipath $s $P $opt $XC $Z"
fi
}
[ $S ] &&break
}
}
set +f;unset IFS
}

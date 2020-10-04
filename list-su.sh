fc(){
local unset O P re p n z s
[[ $1 =~ ^\./[^/] ]] || re=.* # it's recursively at any depth if no prefix ./
a=${1#./}
[[ $a =~ ^(.*[^/])(/+)$ ]] &&{
a=${BASH_REMATCH[1]}; z=${BASH_REMATCH[2]}
}
a=${a//\/.\///}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		if [ $re ] ;then
			fx=${BASH_REMATCH[3]}	# fx is first explicit path
			s=~+/${BASH_REMATCH[1]}
			while [[ $s =~ [^/.]+/\.\.(/|$) ]] ;do s=${s/${BASH_REMATCH[0]}}; done
			[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s \\n from $a>&2;continue;}
			s=${s%/}
			while [[ $fx =~ [^/.]+/\.\.(/|$) ]] ;do fx=${fx/${BASH_REMATCH[0]}}; done
			[[ $fx =~ ^/..(/|$) ]] &&{
				fx=${fx#/};fx=${fx##../}
				[ $fx = .. ] && fx=/*
			}
			a=**$fx
		else
			a=~+/$a
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		if [ $re ] ;then
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			a=${a##../};[ $a = .. ]&&a=
			a=$PWD**/$a
		else
			a=~+/$a
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
D="-type d"
F="-type f"
K="-type l"
R="-print"
if [[ $z = / ]] ;then F=;K=;R=
elif [[ $z = // ]] ;then D=;K=;R=
elif [[ $z = /// ]] ;then D=;F=;R=
else	O=-o
fi
if [ $E ] ;then
	[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
	s=${BASH_REMATCH[1]}
	p=${BASH_REMATCH[3]}
	X="\! -${2}regex ^$p$ \( $D $O $F $O $K $O $R \)"
elif [[ $a =~ [*?] ]] ;then
	a=${a//./\\\\.}
	[[ $a =~ ^(.*/(.*\*\*)?)(.*) ]]
	p=${BASH_REMATCH[1]}
	n=${BASH_REMATCH[3]}
	if [ $s ] ;then
		p=${p//\*\*/~\}\{}
		p=${p//\*/[^/]*}
		p=${p//~\}\{/.*}
		p=${p//\?/[^/.]}
		n=${n//\\.\*/\\\\.[^/]+}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		X="\! -${2}regex ^$s$p$n$ \( $D $O $F $O $K $O $R \)"
	else
		[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
		s=${BASH_REMATCH[1]}
		: ${s:=/}
		p=${p//\*\*/~\}\{}
		p=${p//\*/[^/]*}
		p=${p//~\}\{/.*}
		p=${p//\?/[^/.]}
		n=${n//\\.\*/\\\\.[^/]+}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		X="\! -${2}regex ^$p$n$ \( $D $O $F $O $K $O $R \)"
	fi
else
	if [ -d "$a" ];then s=$a
	else
		s=${a%/*}
		X="\! -${2}path $a"
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
unset po opt E X d l lx
de=0;I=i r=%p
set -f;trap 'set +f;unset IFS' 1 2
for e
{
case $e in
-[HDLPO]) po=$e;;
-h|--help) find --help | sed -E "1,3s/find/$FUNCNAME/";return;;
-ex=?*|-exc=?*)
	[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*))(\ *[1-9&]>|[><|])? ]]
	A=${BASH_REMATCH[2]}
	: ${A:=${BASH_REMATCH[3]}}
	: ${A:=${BASH_REMATCH[4]}}
	A=$A
	[[ $A =~ (--?[[:alnum:]]+(=.+)?\ +)*(.*) ]]
	eval set -- "${BASH_REMATCH[1]}"
	for a;{ [[ $a =~ ^-exc?=(.+)$ ]] &&{ fc ${BASH_REMATCH[1]} $I;break;} }
	;;
-de) de=1;;
-cs) I=;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]|-[1-9][0-9])
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-[1-9]|-[1-9][0-9]) d=-maxdepth\ ${e:1};;
-E) E=1;;
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate more specific sub-option, ignoring;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a full path name, put it after - or --;;
*) break;;
esac
}

[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*))(\ *[1-9&]>|[><|])? ]]
A=${BASH_REMATCH[2]}
: ${A:=${BASH_REMATCH[3]}}
: ${A:=${BASH_REMATCH[4]}}
[[ $A =~ (--?[[:alnum:]]+(=.+)?\ +)*(--?\ )?(.*) ]]
A=${BASH_REMATCH[4]}

[[ $A =~ ^[[:space:]]*$ ]] &&{ eval "sudo find $po ~+ $d \! -ipath ~+ $opt \( -type d -printf \"$r/\n\" -o -printf \"$r\n\" \)"; set +f;return; }
IFS=$'\n'
A=${A//\\/\\\\}
eval set -- $A
for a
{
unset O P S re p n z s

a=${a#\\\\}
[[ $a =~ ^\./[^/] ]] || re=.* # it's recursively at any depth if no prefix ./
a=${a#./}

[[ $a =~ ^(.*[^/])(/+)$ ]] &&{
a=${BASH_REMATCH[1]}; z=${BASH_REMATCH[2]}
}
a=${a//\/.\///}
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		if [ $re ] ;then
			fx=${BASH_REMATCH[3]}	# fx is first explicit path
			s=~+/${BASH_REMATCH[1]}
			while [[ $s =~ [^/.]+/\.\.(/|$) ]] ;do s=${s/${BASH_REMATCH[0]}}; done
			[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s \\n from $a>&2;continue;}
			s=${s%/}
			while [[ $fx =~ [^/.]+/\.\.(/|$) ]] ;do fx=${fx/${BASH_REMATCH[0]}}; done
			[[ $fx =~ ^/..(/|$) ]] &&{
				fx=${fx#/};fx=${fx##../}
				[ $fx = .. ] && fx=/*
			}
			[[ ! $a =~ [*?] ]] &&{
				P="-regextype posix-extended -${I}regex ^$s$fx$ \( -type d -exec find '{}' \; -o -print \) -o -${I}regex ^$s.*$fx$ -print"
			}
			a=**$fx
		else
			a=~+/$a
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	else
		if [ $re ] ;then
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			a=${a##../};[ $a = .. ]&&a=
			[[ ! $a =~ [*?] ]] &&{
				s=~+/$a;s=${s%/*}
				P="-regextype posix-extended -${I}regex ^$PWD/$a$ \( -type d -exec find '{}' \; -o -print \) -o -${I}regex ^$PWD.*/$a$ -print"
			}
			a=$PWD**/$a
		else
			a=~+/$a
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
K="-type l -printf \"$r\n\""
R="-print"
if [[ $z = / ]] ;then F=;K=;R=
elif [[ $z = // ]] ;then D=;K=;R=
elif [[ $z = /// ]] ;then D=;F=;R=
else	S="\( $D -o -print \)"
fi
if [ -z $P ] ;then
	S=${S-"\( $D $O $F $O $K $O $R \)"}
	if [ $E ] ;then
		[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
		P="-regextype posix-extended -${I}regex ^$p$"
	elif [[ $a =~ [*?] ]] ;then
		a=${a//./\\\\.}
		[[ $a =~ ^(.*/(.*\*\*)?)(.*) ]]
		p=${BASH_REMATCH[1]}
		n=${BASH_REMATCH[3]}
		if [ $s ] ;then
			p=${p//\*\*/~\}\{}
			p=${p//\*/[^/]*}
			p=${p//~\}\{/.*}
			p=${p//\?/[^/.]}
			n=${n//\\.\*/\\\\.[^/]+}
			n=${n//\?/[^/.]}
			n=${n//\*/[^/]*}		
			P="-regextype posix-extended -${I}regex ^$s$p$n$"
		else
			[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
			s=${BASH_REMATCH[1]}
			: ${s:=/}
			p=${p//\*\*/~\}\{}
			p=${p//\*/[^/]*}
			p=${p//~\}\{/.*}
			p=${p//\?/[^/.]}
			n=${n//\\.\*/\\\\.[^/]+}
			n=${n//\?/[^/.]}
			n=${n//\*/[^/]*}
			P="-regextype posix-extended -${I}regex ^$p$n$"
		fi
	else
		if [ -d "$a" ] ;then
			s=$a
		else
			s=${a%/*}
			P="-${I}path $a"
		fi
	fi
fi
((l)) &&{
	[ -z $lx ] &&ll=-prune
	D="-type d $ll -exec find \{\} $lx $opt \( $D -o -printf '%p\n' \) \;"
}
if((de+I)) &&([ $F ] ||[ $K ]) ;then
	export -f di
	F="$F $O $K"
	eval "LC_ALL=C find $po $s $d \! -ipath $s $X $P $opt $X \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o} $D $O $R \)"
else
	command 2> >(while read s;do echo -e "\e[01;31m$s\e[m" >&2; done) eval "LC_ALL=C sudo find $po $s $d \! -ipath $s $P $opt $X $S"
fi
}
set +f;unset IFS
}

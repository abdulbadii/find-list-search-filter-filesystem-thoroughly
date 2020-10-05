fc(){
local unset O P re p n s z Z
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
			[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom $PWD$a>&2;continue;}
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
if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$K
fi
if [ $E ] ;then
	X="\! -${2}regex ^$a$ $Z"
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
		X="\! -${2}regex ^$s$p$n$ $Z"
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
		X="\! -${2}regex ^$p$n$ $Z"
	fi
else
	X="\! -${2}path $a $Z"
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
unset IFS po opt E X XC d l lx
de=0;I=i r=%p
set -f;trap 'set +f;unset IFS' 1 2
for e
{
case $e in
-[HDLPO]) po=$e;;
-h|--help) find --help | sed -E "1,3s/find/$FUNCNAME/";return;;
-ex=?*|-exc=?*)
	[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*)) ]]
	A=${BASH_REMATCH[2]}
	: ${A:=${BASH_REMATCH[3]}}
	: ${A:=${BASH_REMATCH[4]}}
	[[ $A =~ (-[[:alnum:]]+(=.+)?\ +)*-exc?=(.+) ]]
	eval set -- ${BASH_REMATCH[3]}
	eval set -- $1
	for a;{
		fc $a $I
		XC=$XC$X' '
	}
	I=i;;
-[1-9]|-[1-9][0-9]) d=-maxdepth\ ${e:1};;
-de) de=1;;
-in) in=1;;
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
}

[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*)) ]]
A=${BASH_REMATCH[2]}
: ${A:=${BASH_REMATCH[3]}}
: ${A:=${BASH_REMATCH[4]}}
[[ $A =~ (--?[[:alnum:]]+(=.+)?\ +)*(--?\ )?(.*) ]]
A=${BASH_REMATCH[4]}

A=${A//\\/\\\\}
[[ $1 =~ ^\ *$ ]] && A=\'\'

IFS=$'\n';eval set -- $A
for e
{
unset i re z
[[ $e =~ ^\./[^/] ]] || re=.* # it's recursively at any depth if no prefix ./
e=${e#./}

[[ $e =~ ^(.*[^/])?(/+)$ ]] &&{ # Get /, // dir. file etc filter command 
	e=${BASH_REMATCH[1]}
	z=${BASH_REMATCH[2]}
	[[ $e = \\ ]] &&{	e=/;	z=${z#/}; }
}
IFS=$'\\';eval set -- ${e//\/.\///}
B=${1%/*}/

for a ;{
unset P Z p n s
if ((i)) ;then
	a=$B$a
else
	i=1
	a=$a
fi

D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
K="-type l -printf \"$r\n\""
R="-print"
if [[ $z = / ]] ;then Z=$D
elif [[ $z = // ]] ;then Z=$F
elif [[ $z = /// ]] ;then Z=$K
else	Z="\( $D -o -print \)"
fi
if [[ $a =~ ^/ ]] ;then
	while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
	[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
else
	if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
		if [ $re ] ;then
			fx=${BASH_REMATCH[3]}	# fx is first explicit path
			s=~+/${BASH_REMATCH[1]}
			while [[ $s =~ [^/.]+/\.\.(/|$) ]] ;do s=${s/${BASH_REMATCH[0]}}; done
			[[ $s =~ ^/..(/|$) ]] &&{ echo -e Invalid actual path: $s\\nfrom ~+/$a>&2;continue;}
			s=${s%/}
			while [[ $fx =~ [^/.]+/\.\.(/|$) ]] ;do fx=${fx/${BASH_REMATCH[0]}}; done
			[[ $fx =~ ^/..(/|$) ]] &&{
				fx=${fx#/};fx=${fx##../}
				[ $fx = .. ] && fx=/*
			}
			[[ $fx =~ ^[^*?]+$ ]] &&{
				P="-regextype posix-extended -${I}regex ^$s$fx$ \( -type d -exec find '{}' $Z \; -o -print \) -o -${I}regex ^$s.*$fx$ -print"
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
			a=${a##../};[[ $a = .. ]]&&a=
			if [[ $a =~ ^[^*?]+$ ]] ;then
				s=~+/$a
				P="-regextype posix-extended -${I}regex ^$s$ \( -type d -exec find '{}' $Z \; -o -print \) -o -${I}regex ^$PWD.*/$a$ -print"
				s=${s%/*}
			else	a=$PWD**/$a;a=${a%/}
			fi
		else
			a=~+/$a
			while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
			[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
		fi
	fi
fi
((l)) &&{
	[ -z $lx ] &&l=-prune
	D="-type d $l -exec find \{\} $lx $opt \( $D -o -print \) \;"
}

if [ -z $P ] ;then
	if [ -z $a ] ;then
		s=~+
	elif [ $E ] ;then
		[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
		s=${BASH_REMATCH[1]}
		p=${BASH_REMATCH[3]}
		P="-regextype posix-extended -${I}regex ^$s$p$"
	elif [[ $a =~ [*?] ]] ;then
		a=${a//./\\\\.}
		[[ $a =~ ^(.*/?(.*\*\*)?)(.*) ]]
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
if((de+in)) &&[ "$F" -o "$K" ] ;then
	export -f di
	F="$F $O $K"
	eval "LC_ALL=C find $po $s $d \! -ipath $s $XC $P $opt $X \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $de \$0 \$@' '{}' + -o} $D $O $R \)"
else
	command 2> >(while read s;do echo -e "\e[01;31m$s\e[m" >&2; done) eval "LC_ALL=C sudo find $po $s $d \! -ipath $s $P $opt $XC $Z"
fi
}
}
set +f;unset IFS
}

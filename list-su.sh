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
unset po opt E xc x l lx
d=0;I=i; r=%p
for e
{
case $e in
-[HDLPO]) po=$e;;
-h|--help)
	find --help | sed -E "1,3s/find/$FUNCNAME/"
	return;;
--ex|--exc)
	[[ $e =~ --exc?=(.+) ]]
	xc=${BASH_REMATCH[1]};;
-d) d=1;;
-cs) I=;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]*)
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-[1-9]*) x=-maxdepth\ ${e:1};;
-E) E=1;;
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate more specific sub-option, ignored;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a full path name, put it after - or --;;
*) break;;
esac
}
set -f;trap 'set +f;unset IFS' 1 2

[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*))(\ *[1-9&]>|[><|])? ]]
A=${BASH_REMATCH[2]}
: ${A:=${BASH_REMATCH[3]}}
: ${A:=${BASH_REMATCH[4]}}
[[ $A =~ (--?[[:alnum:]]+\ ?)*(.*) ]]
A=${BASH_REMATCH[2]}

[[ $A =~ ^[[:space:]]*$ ]] &&{ eval "sudo find $po ~+ $x \! -ipath ~+ $opt \( -type d -printf \"$r/\n\" -o -printf \"$r\n\" \)"; set +f;return; }
IFS=$'\n'
A=${A//\\/\\\\}
eval set -- $A
for a
{
unset O P ll re p n z s
if [[ $a = \\/ ]] ;then	a=/
else
	[[ $a =~ ^(.*[^/])(/+)$ ]] &&{ z=${BASH_REMATCH[2]};a=${BASH_REMATCH[1]};}
	a=${a//\/.\///}
	[[ $a =~ ^\./ ]] || re=.* # may be recursively at any depth if no prefix ./
	a=${a#./}
	if [[ $a =~ ^/ ]] ;then
		while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
		[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
	else
		if [[ $a =~ ^(\.\.(/\.\.)*)(/.+)? ]] ;then
			if [ $re ] ;then
				fx=${BASH_REMATCH[3]}	# fx is first explicit path
				a=~+/${BASH_REMATCH[1]}
				while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
				[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
				s=$a
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
				a=${a##../}
				[ $a = .. ] &&a=
				a=$PWD**/$a
			else
				a=~+/$a
				while [[ $a =~ [^/.]+/\.\.(/|$) ]] ;do a=${a/${BASH_REMATCH[0]}}; done
				[[ $a =~ ^/..(/|$) ]] &&{ echo Invalid actual path: $a >&2;continue;}
			fi
		fi
	fi
fi

if [[ $a =~ \* ]] ;then
	a=${a//./\\.}
	[[ $a =~ ^(.*/(.*\*\*)?)(.*) ]]
	p=${BASH_REMATCH[1]}
	n=${BASH_REMATCH[3]}
	if [ $s ] ;then
		p=${p//\*\*/~\}\{}
		p=${p//\*/[^/]*}
		p=${p//~\}\{/.*}
		p=${p//\?/[^/.]}
		n=${n//\\.\*/\\.[^/]+}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}		
		P="-regextype posix-extended -${I}regex ^$s$p$n\$"
	else
		a=${a//./\\.}
		[[ $a =~ ^((/[^/*?]+)*)(/.+)?$ ]]
		s=${BASH_REMATCH[1]}
		: ${s:=/}
		p=${p//\*\*/~\}\{}
		p=${p//\*/[^/]*}
		p=${p//~\}\{/.*}
		p=${p//\?/[^/.]}
		n=${n//\\.\*/\\.[^/]+}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		P="-regextype posix-extended -${I}regex ^$p$n\$"
	fi
else
	if [ -d "$a" ] ;then
		s=$a
	else
		s=${a%/*}
		P="-${I}path $a"
	fi
fi

D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
K="-type l -printf \"$r\n\""
R="-printf \"$r\n\""
if [[ $z = / ]] ;then F=;K=;R=
elif [[ $z = // ]] ;then D=;K=;R=
elif [[ $z = /// ]] ;then D=;F=;R=
else	O=-o
fi

((l)) &&{
	z=${lx--prune};z=${z%$lx}
	D="-type d $z -exec find \{\} $lx $opt \( $D -o -printf '%p\n' \) \;"
}
if((d+I));then
	export -f di
	F="$F $O $K"
	eval "find $po $s $x \! -ipath $s $P $opt \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $d \$0 \$@' '{}' + -o} $D $O $R \)"
else
	command 2> >(while read s;do echo -e "\e[01;31m$s\e[m" >&2; done) eval "sudo find $po $s $x \! -ipath $s $P $opt \( $D $O $F $O $K $O $R \)"
fi
}
set +f;unset IFS
}

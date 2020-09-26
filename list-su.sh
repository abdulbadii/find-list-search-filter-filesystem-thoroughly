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
unset po opt E xc x lx l
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
-[ac-il-x]) echo \'$e\' : inadequate specific sub-option, ignored;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-[!-]*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a full path name, put it after - or --;;
*) break;;
esac
}
set -f;trap 'set +f;unset IFS' 1 2

[[ `history 1` =~ ^\ *[0-9]+\ +(.+\$\(\ *$FUNCNAME\ +(.*)\)|.+\`\ *$FUNCNAME\ +(.*)\`|.*$FUNCNAME\ +(.*))(\ [1-9&]>|[><|])? ]]
A=${BASH_REMATCH[2]}
: ${A:=${BASH_REMATCH[3]}}
: ${A:=${BASH_REMATCH[4]}}
[[ $A =~ (--?[[:alpha:]]+\ ?)*(.*) ]]
A=${BASH_REMATCH[2]}

[[ $A =~ ^[[:space:]]*$ ]] &&{ eval "sudo find $po ~+ $x \! -ipath ~+ $opt \( -type d -printf \"$r/\n\" -o -printf \"$r\n\" \)"; set +f;return; }
IFS=$'\n'
eval set -- $A
for a
{
unset O P ll re p n z

if [[ $a = \\/ ]] ;then	a=/
else
	[[ $a =~ ^\./ ]] || re=.*/ # must be recursive if no prefix ./
	a=${a#./}
	z=${a: -1}
	a=${a%[./\\]}
	[ $a ] &&{
		[[ $a =~ ^(.*/)?([^/]*)$ ]]
		p=${BASH_REMATCH[1]}
		n=${BASH_REMATCH[2]}
		if [[ $n = .. ]] ;then p=$p..;unset n
		elif [[ $n = . ]] && [[ $z = . ]] ;then p=$p..;unset n z
		fi
	}
fi
if [[ $n =~ \*\* ]] ;then #double wildcards in name is moved to dir. path
	p=$p${n%\*\**}**
	n=${n##*\*\*}
fi
if [ "${a:0:1}" = / ];then # Absolute Dir. Path
	if [ $E ] ;then
		s=${p%%[*?\\\{\[]*}
		s=${s%/*}
		s=${s:-/}
		E="$a.*"
	elif [[ $a =~ \* ]] ;then # If any wildcard, convert to regex
		n=${n//./\\.}
		n=${n//.\*/\\.[^/]+}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		if [[ $p =~ \* ]] ;then # if any wildcard in dir. path
			s=${p%%[*?]*}
			s=${s%/*}
			s=${s:-/}
			p=${p//./\\.}
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
		else
			s=$p
		fi
		P="-regextype posix-extended -${I}regex ^$p$n\$"
	else
		if [ -d "$a" ] ;then
			s=$a
		else
			s=$p
			P="-${I}path $a"
		fi
	fi
else # Relative Dir. Path
	s=~+
	if [ $E ] ;then E=".*$a.*"
	elif [ $p ] ;then
		while [[ $p =~ ^\.\.(/|$) ]] ;do
			s=${s%/*}
			p=${p#..}
			p=${p#/}
		done
		if [[ $a =~ \* ]] ;then
			p=${p//./\\.}
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
			p=${p//\?/[^/.]}
			n=${n//./\\.}
			n=${n//.\*/\\.[^/]+}
			n=${n//\?/[^/.]}
			n=${n//\*/[^/]*}
			if [ $re ] ;then
				P="-regextype posix-extended -${I}regex ^$s$re$p$n\$"
			else
				P="-regextype posix-extended -${I}regex ^$s/$p$n\$"
				q=/${p%%[*?]*}
				s=$s${q%/*}
			fi
		else
			P=${n+"-${I}path ${re#.}$p$n"}
			[ $P ] && [ -z $re ] && ll=1-l
		fi
	else			# if no dir. path relative to current dir
		if [[ $n =~ \* ]] ;then
			n=${n//./\\.}
			n=${n//.\*/\\.[^/]+}
			n=${n//\*/[^/]*}
			n=${n//\?/[^/.]}
		elif [ $n ] ;then
			[ $re ] ||let ll=1-l
		else n=[^/]+
		fi
		P="-regextype posix-extended -${I}regex ^$s${re%/}/$n\$"
	fi
fi
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
K="-type l -printf \"$r\n\""
R="-printf \"$r\n\""
if [[ $z = / ]] ;then F=;K=;R=
elif [[ $z = . ]] ;then	D=;K=;R=
elif [[ $z = \\ ]] ;then D=;F=;R=
else	O=-o
fi

if [ $E ] ;then
	A="find $po $s $x \! -ipath $s -regextype posix-extended -${I}regex $E $opt \( $D $O $F $O $K $O $R \)"
elif((ll)) ;then
	if((d+I));then
		export -f di
		F="$F $O $K"
		F="${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $d \$0 \$@' '{}' + -o}"
		eval "find $po $s \! -ipath $s $P $opt \( -type d -exec find \{\} $x $opt \; \( $F $D $O $R \) -o $F -printf \"$r\n\" \)"
	else
		#set -o pipefail
		#(eval "sudo find $po $s \! -ipath $s $P $opt \( -type d -exec find \{\} $x $opt \( $D $O $F $O $K $O $R \) \; -o -printf \"$r\n\" \)" 2>&1>&3 | sed -E $'s/:(.+):\s(.+)/:\e[1;36m\\1:\e[41;1;37m\\2\e[m/'>&2) 3>&1
		command 2> >(while read s;do echo -e "\e[01;31m$s\e[m" >&2; done) eval "sudo find $po $s \! -ipath $s $P $opt \( -type d -exec find \{\} $x $opt \( $D $O $F $O $K $O $R \) \; -o -printf \"$r\n\" \)"
	fi
	unset ll
else
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
fi
}
set +f;unset IFS
}

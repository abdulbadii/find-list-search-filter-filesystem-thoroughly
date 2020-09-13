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
unset po opt I E xc ct x lx l
d=0;r=%p
for e
{
case $e in
-[HDLPO]) po=$e;;
-h|--help)
	find --help | sed -E "1,3s/find/$FUNCNAME/"
	return;;
--ex|--exc)
	[[ $e =~ --exc?=([\!-~A-z]+) ]]
	xc=${BASH_REMATCH[1]};;
-d) d=1;;
-i) I=1;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]*)
	((${e:2})) &&lx=-maxdepth\ ${e:2};l=1;;
-[1-9]*) x=-maxdepth\ ${e:1};;
-E) E=1;;
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate specific sub-option, ignoring.;;
-[ac-il-x]?*) opt=$opt$e\ ;;
-|--) let ++ct;break;;
-*) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a full path name, put it after - or --;;
*) break;;
esac
let ++ct
}
xt=${@:1:ct}
set -f;trap 'set +f;unset IFS' 1 2
if [[ $@ =~ \* ]] ;then
	A=${@#*$xt}
	A=${A//\\/\\\\}
else
	A=`history 1`;A=${A//  / }
	A=${A# *[0-9]*$FUNCNAME*$xt}
	A=${A%% [12]>*}
	A=${A%%[>&|<]*}
fi
[[ $A =~ ^[[:space:]]*$ ]] &&{ eval "find $po ~+ $x \! -ipath ~+ $opt \( -type d -printf \"$r/\n\" -o -printf \"$r\n\" \)"; set +f;return; }

IFS=$'\n'
eval set -- $A
for a
{
unset O P ll re p n

z=${a: -1}
a=${a%[./\\]}
if [[ $a =~ ^\\ ]] ;then	a=/;p=/
else
	[[ $a =~ ^./ ]] || re=.*/ # must be recursive if no prefix ./
	a=${a#./}
	[[ $a =~ ^(.*/)?([^/]*)$ ]]
	p=${BASH_REMATCH[1]}
	n=${BASH_REMATCH[2]}
fi
if [[ $n =~ \*\* ]] ;then #double wildcards in name is moved to dir. path
	p=$p${n%\*\**}**
	n=${n##*\*\*}
fi
if [ "${p:0:1}" = / ];then # Absolute Dir. Path
	if [ $E ] ;then
		s=${p%%[*?\\\{\[]*}
		s=${s%/*}
		s=${s:-/}
		E="$a.*"
	elif [[ $a =~ \* ]] ;then # If any wildcard, convert to regex
		n=${n//./\\.}
		n=${n//.\*/\\.\\S[^/]*}
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
		P="-regextype posix-extended -iregex ^$p$n\$"
	else
		P="-ipath $a"
		if [ -d "$a" ] ;then
			s=$a
			P=$P*
		else	s=$p
		fi
	fi
else # Relative Dir. Path
	s=~+
	if [ $E ] ;then E=".*$a.*"
	elif [ $p ] ;then
		while [[ $p =~ ^../ ]] ;do
			s=${s%/*}
			p=${p#../}
			p=${p#./}
		done
		if [[ $a =~ \* ]] ;then
			p=${p//./\\.}
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
			p=${p//\?/[^/.]}
			n=${n//./\\.}
			n=${n//.\*/\\.\\S[^/]*}
			n=${n//\?/[^/.]}
			n=${n//\*/[^/]*}
			if [ $re ] ;then
				P="-regextype posix-extended -iregex ^$s$re$p$n\$"
			else
				P="-regextype posix-extended -iregex ^$s/$p$n\$"
				q=/${p%%[*?]*}
				s=$s${q%/*}
			fi
		else
			P="-ipath ${re#.}$p$n"
			[ $re ] || ll=1
		fi
	else			# Only one depth dir./filename relative to current dir
		[[ $a = . ]] &&{ s=${s%/*}; a=;n=;}
		n=${n:-*}
		if [[ $n =~ \* ]] ;then
			n=${n//.\*/\\.\\S[^/]*}
			n=${n//\*/[^/]*}
			n=${n//./\\.}
			n=${n//\?/[^/.]}
			P="-regextype posix-extended -iregex ^$s$re$n\$"
		elif [ $re ] ;then
			P="-iname $n"
			let ll=1-l
		else
			P="-ipath $s/$n"
			let ll=1-l
		fi
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
	A="find $po $s $x \! -ipath $s -regextype posix-extended -iregex $E $opt \( $D $O $F $O $K $O $R \)"
elif((ll)) ;then
	if((d+I));then
		export -f di
		F="$F $O $K"
		F="${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $d \$0 \$@' '{}' + -o}"
		eval "find $po $s \! -ipath $s $P $opt \( -type d -exec find \{\} $x -iname * $opt \; \( $X $D $O $R \) -o $X -printf \"$r\n\" \)"
	else
		set -o pipefail;
		(eval "find $po $s \! -ipath $s $P $opt \( -type d -exec find \{\} $x -iname * $opt \( $D $O $F $O $K $O $R \) \; -o -printf \"$r\n\" \)" 2>&1>&3 | sed -E $'s/:(.+):\s(.+)/:\e[1;36m\\1:\e[41;1;37m\\2\e[m/'>&2 ) 3>&1
	fi
	unset ll
else
	if((l)) ;then
		z=${lx--prune};z=${z%$lx}
		D="-type d $z -exec find \{\} $lx -iname * $opt \( $D -o -printf '%p\n' \) \;"
	fi
	if((d+I));then
		export -f di
		F="$F $O $K"
		eval "find $po $s $x \! -ipath $s $P $opt \( ${F:+\( -type f -o -type l \) -exec /usr/bin/bash -c 'di $d \$0 \$@' '{}' + -o} $D $O $R \)"
	else
		set -o pipefail;
		(eval "find $po $s $x \! -ipath $s $P $opt \( $D $O $F $O $K $O $R \)" 2>&1>&3 | sed -E $'s/:(.+):\s(.+)/:\e[1;36m\\1:\e[41;1;37m\\2\e[m/'>&2 ) 3>&1
	fi
fi
}
set +f;unset IFS
}

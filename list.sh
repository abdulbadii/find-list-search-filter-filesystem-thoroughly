fd(){
	f=`file $3`
	e=`echo $f|sed -E 's/[^:]+:\s+\S+\s+(\S+(\s+\S+){2}).+/\1/;s/Intel$/32bit/'`
	if [[ $e =~ ^execu ]];then echo $e
	else echo $f|sed -E 's/[^:]+:\s*(.+)/\1/';fi
	(($2))&&ldd $3 2>/dev/null |sed -Ee 's/[^>]+>(.+)\s+\(0.+/\1/ ;1s/.*/DEP:&/ ;1! s/.*/    &/'
}
l(){
unset a E opt ex d I i x L l lx; r=%p
for e
{
((i++))
case $e in
-h|--help)
	find --help | sed -E '1,3{s/(:\s+)find/\1lf/}'
	return;;
-d) d=1;;
-i) I=1;;
-l) lx=-maxdepth\ 1; l=1;;
-l[0-9]*)
	[ ! ${e:2} = 0 ] &&lx=-maxdepth\ ${e:2}
	l=1;;
-[1-9]*) x=-maxdepth\ ${e:1};;
-E) E=1;;
-s) r=%s\ $r;;
-t) r="$r %Tr %Tx";;
-st) r='%s %p %Tr %Tx';;
-[ac-il-x]) echo \'$e\' : inadequate specific sub-option, ignoring it.;;
-[ac-il-x]?|-[HDLPO]) opt=$opt$e\ ;;
-?) echo \'$e\' : unrecognized option, ignoring it. If it\'s meant a filename, put it after - or --;;
-|--) break;;
*) ex=1; break;;
esac
}
xt=${@:1:((i-ex))}
set -f
trap 'set +f;unset IFS' 1 2
if [[ $@ =~ \* ]] ;then
	A=$@
else
A=`history 1`
A=${A# *[0-9]*${FUNCNAME}*$xt}
A=${A%% [12]>*}
A=${A%%[>&|<]*}
fi
[[ $A =~ ^[\ \\t]*$ ]] &&{ eval "sudo find ~+ \! -ipath ~+ $opt -type d -printf \"$r/\n\" -o -type f -printf \"$r\n\""; set +f;return; }

eval set -- "${A//\\/\\\\}"
IFS=$'\n'
for a
{
unset O P L
z=${a: -1}
[ "${a:0:2}" = "\/" ] &&{ eval "sudo find / \! -ipath / $opt -type d -printf \"$r/\n\" -o -type f -printf \"$r\n\"";continue; }
a=${a%[/.]}
if [ -z $a ] ;then
	[ $z = . ] &&{ sudo find ~+ -type f; }
	[ $z = / ] &&{ sudo find ~+ \! -ipath ~+ -type d -printf $r/\\n; }
else
[ "${a:0:2}" = ./ ]; re=$? # defaults to recursive if no prefix ./
a=${a#./}
[[ $a =~ ^(.*/)?([^/]+)$ ]]
p=${BASH_REMATCH[1]}
n=${BASH_REMATCH[2]}

D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
[ $l ] && L="-exec find \{\} $lx \! -ipath \{\} -iname * $opt $D $O $F \;"
if [ $z = . ] ;then	D=
elif [ $z = / ] ;then	F=
else	O=-o
fi

if [ $p ] ;then # If it has dir. path it is possibly either absolute or relative
if [ ${p:0:1} = / ];then # Absolute Dir. Path
	[ $E ] &&{ A="sudo find $s $x -regextype posix-extended -iregex \"*$s/$p$n*\" $opt \( $D $O $F";return; }
	s=${p%%[*?]*}
	s=${s%/*}
	s=${s:-/}
	n=${n//./\\.}
	n=${n//.\*/\\.\\S[^/]*}
	n=${n//\?/[^/.]}
	n=${n//\*/'[^/]*'}
	if [[ $p =~ \*\* ]] ;then # if double wildcards in path
		p=${p//\*\*/~\{~}
		p=${p//\*/[^/]+}
		p=${p//~\{~/.*}
		P="-regextype posix-extended -iregex ^$p$n\$"
	elif [[ ! $p =~ \* ]] ;then # if not at all
		P="-regextype posix-extended -iregex ^$p$n\$"
	else # One wildcard in dir. path
		P="-regextype posix-extended -iregex ^$s/${p//\*/[^/]+}$n\$"
	fi
else # Relative Dir. Path
	s=~+
	while [ ${p:0:3} = ../ ] ;do
		s=${s%/*}
		p=${p#../}
		p=${p#./}
	done
	[ $E ] &&{ A="sudo find $s $x -regextype posix-extended -iregex \"*$s/$p$n*\" $opt \( $D $O $F";return; }
	if ((re)) ;then
		P="-ipath *$p$n"
	else
		n=${n//./\\.}
		n=${n//.\*/\\.\\S[^/]*}
		n=${n//\?/[^/.]}
		n=${n//\*/'[^/]*'}
		if [[ $p =~ \* ]] ;then # if any wildcard in path
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
			q=\ ${p%%[*?]*}
			q=${q%[ /]*}
			t=$s
			s=$s${q# }
			P="-regextype posix-extended -iregex ^$t/$p$n\$"
		else
			L="-exec find \{\} \! -ipath \{\} -iname * $opt $D $O $F \;"
		fi
	fi
fi

else # If no dir. path, it'd be one depth dir./filename relative to PWD
	s=~+
	[ $E ] &&{ A="sudo find $s $x -regextype posix-extended -iregex \"*$s/$p$n*\" $opt \( $D $O $F";return; }
	if((re)) ;then
		P="-iname $n"
	else
		if [[ $n =~ \* ]] ;then
			n=${n//./\\.}
			n=${n//.\*/\\.\\S[^/]*}
			n=${n//\?/[^/.]}
			n=${n//\*/'[^/]*'}
			P="-regextype posix-extended -iregex ^$s/$n\$"
		else # if no wildcard at all
			P="-ipath $s/$n"
			L="-exec find \{\} \! -ipath \{\} -iname * $opt $D $O $F \;"
		fi
	fi
fi

A="sudo find $s $x $P $opt \( $D $L $O $F"

if((d+I));then
	export -f fd;eval $A -exec bash -c \'fd $d $i \$0\' {} '\; \)'
else
	set -o pipefail;
	(eval "$A \)" 2>&1>&3 | sed -E $'s/:(.+):(.+)/:\e[1;36m\\1:\e[1;31m\\2\e[m/'>&2 ) 3>&1
fi
fi
}
set +f;unset IFS
}

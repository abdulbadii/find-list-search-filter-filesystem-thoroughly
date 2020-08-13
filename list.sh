di(){
	if((1)) ;then
		f=`file $3`
		e=`echo $f|sed -E 's/[^:]+:\s+\S+\s+(\S+(\s+\S+){2}).+/\1/;s/Intel$/32bit/'`
		if [[ $e =~ ^execu ]];then echo $e
		else echo $f|sed -E 's/[^:]+:\s*(.+)/\1/'
		fi
	fi
	(($2))&&ldd $3 2>/dev/null |sed -Ee 's/[^>]+>(.+)\s+\(0.+/\1/ ;1s/.*/DEP:&/ ;1! s/.*/    &/'
}
l(){
unset a E opt ex i x lx l L
d=0; I=0; r=%p
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
[[ $A =~ ^[\ \\t]*$ ]] &&{ eval "find ~+ \! -ipath ~+ $opt -type d -printf \"$r/\n\" -o -type f -printf \"$r\n\""; set +f;return; }

eval set -- "${A//\\/\\\\}"
IFS=$'\n'
for a
{
unset O P ll re p n
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""

z=${a: -1}
if [ $z = . ] ;then	D=
elif [ $z = / ] ;then	F=
else	O=-o
fi

a=${a%[/.]}
if [ -z $a ] ;then
	[ $z = / ] && P=" \! -ipath ${PWD}"
else
[ "$a" = \\ ] &&{ eval "find / \! -ipath / $opt -type d -printf \"$r/\n\" -o -type f -printf \"$r\n\"";continue; }
[ "${a:0:2}" = ./ ]; re=$? # defaults to recursive if no prefix ./
a=${a#./}
[[ $a =~ ^(.*/)?([^/]+)$ ]]
p=${BASH_REMATCH[1]}
n=${BASH_REMATCH[2]}
fi

p=$p${n%%\*\**}** #double wildcards in name is moved to dir. path
n=${n##*\*\*}
if [ $p ] ;then # If it has dir. path it is possibly either absolute or relative
if [ ${p:0:1} = / ];then # Absolute Dir. Path
	if [ $E ] ;then
		s=${p%%[*?\\\{\[]*}
		s=${s%/*}
		P="-regextype posix-extended -iregex \"*$s/$p$n*\""
	elif [[ $a =~ \* ]] ;then
		s=${p%%[*?]*}
		s=${s%/*}
		s=${s:-/}
		p=${p//\*\*/~\{~}
		p=${p//\*/[^/]+}
		p=${p//~\{~/.*}
		n=${n//./\\.}
		n=${n//.\*/\\.\\S[^/]*}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		if [[ ! $p =~ \* ]] ;then # if no wildcard at all in dir. path
			P="-regextype posix-extended -iregex ^$p$n\$"
		else P="-regextype posix-extended -iregex ^$p$n\$"
		fi
	else
		if [ -d $a ] ;then
			s=$a; P="-iname *"
		else s=$p; P="-iname $n";fi
	fi
else # Relative Dir. Path
	s=~+
	while [ "${p:0:3}" = ../ ] ;do
		s=${s%/*}
		p=${p#../}
		p=${p#./}
	done
	if [ $E ] ;then
		P="-regextype posix-extended -iregex \"^$s/$p$n*\""
	elif [[ $a =~ \* ]] ;then
		if [[ $p =~ \*\* ]] ;then # if there's any double wildcards in path
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
		elif [[ $p =~ \* ]] ;then
			p=${p//\*/[^/]+}
		fi
		n=${n//./\\.}
		n=${n//.\*/\\.\\S[^/]*}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		P="-regextype posix-extended -iregex ^$s$p$n\$"
	elif ((re)) ;then
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
			l=1
		fi
	fi
fi

else # If no dir. path, it'd be one depth dir./filename relative to PWD
	s=~+
	if [ $E ] ;then P="-regextype posix-extended -iregex \"*$s/$p$n*\" $opt \( $D $O $F"
	elif [ -z ${re+i} ] ;then : # if unset recursive, nop
	elif((re)) ;then
		if [[ $n =~ \*\* ]] ;then
			n=${n//\*\*/~\{~}
			n=${n//.\*/\\.\\S[^/]*}
			n=${n//\*/[^/]*}
			n=${n//./\\.}
			n=${n//~\{~/.*}
			n=${n//\?/[^/.]}
			P="-regextype posix-extended -iregex ^$s/.*$n\$"
		elif [[ $n =~ \* ]] ;then
			P="-iname $n"
		else
			P="-iname $n"
			ll=1
		fi
	else
		if [[ $n =~ \* ]] ;then
			n=${n//./\\.}
			n=${n//.\*/\\.\\S[^/]*}
			n=${n//\?/[^/.]}
			n=${n//\*/'[^/]*'}
			P="-regextype posix-extended -iregex ^$s/$n\$"
		else
			P="-ipath $s/$n"
			ll=1
		fi
	fi
fi

((l+ll)) &&L=${L-"-exec find \{\} $lx \! -ipath \{\} -iname * $opt $D $O $F \;"}
A="find $s $x $P $opt \( $D $L $O $F"
((l)) ||unset L

if((d+I));then
	export -f di;eval $A -exec bash -c \'di $I $d \$0\' {} '\; \)'
else
	set -o pipefail;
	(eval "$A \)" 2>&1>&3 | sed -E $'s/:(.+):(.+)/:\e[1;36m\\1:\e[1;31m\\2\e[m/'>&2 ) 3>&1
fi
}
set +f;unset IFS
}

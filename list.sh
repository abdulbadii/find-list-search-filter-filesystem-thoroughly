di(){
	f=`file $3`
	e=`echo $f | sed -E 's/^[^:]+:[^,]+\s(\S+),.+$/\1/'`
	if [[ $e =~ ^execut ]];then
		echo $f|sed -E 's/[^:]+:\s*(.+)/\t\1/'
		(($2))&&ldd $3 2>/dev/null |sed -E 's/^\s*([^>]+>\s*)?(.+)\s+\(0.+/\t\2/;s/^.*\blinux-vdso\.s.+/DEP:/'
	else
		echo $f|sed -E 's/[^:]+:\s*(.+)/\t\1\n/'
	fi
}
l(){
unset po opt a E ex i x lx l L
d=0; I=0; r=%p
for e
{
((i++))
case $e in
-[HDLPO]) po=$e;;
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
-[ac-il-x]?) opt=$opt$e\ ;;
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
[[ $A =~ ^[\ \\t]*$ ]] &&{ eval "find $po ~+ \! -ipath ~+ $opt -type d -printf \"$r/\n\" -o -printf \"$r\n\""; set +f;return; }

IFS=$'\n'
eval set -- "${A//\\/\\\\}"
for a
{
unset O P ll re p n
D="-type d -printf \"$r/\n\""
F="-type f -printf \"$r\n\""
K="-type l -printf \"$r\n\""
R="-printf \"$r\n\""

z=${a: -1}
if [ $z = . ] ;then	D=;K=;R=
elif [ $z = / ] ;then	F=;K=;R=
elif [ $z = \\ ] ;then	D=;F=;R=
else	O=-o
fi

a=${a%[/.\\]}
if [ -z $a ] ;then
	[ $z = / ] && P=" \! -ipath ${PWD}"
else
[ "$a" = \\ ] &&{ eval "find / \! -ipath / $opt -type d -printf \"$r/\n\" -o -printf \"$r\n\"";continue; }

[[ $a =~ ^(.*/)?([^/]+)$ ]]
p=${BASH_REMATCH[1]}
n=${BASH_REMATCH[2]}
fi

if [[ $n =~ \*\* ]] ;then #double wildcards in name is moved to dir. path
	p=$p${n%%\*\**}**
	n=${n##*\*\*}
fi

if [ "${p:0:1}" = / ];then # Absolute Dir. Path
	if [ $E ] ;then
		s=${p%%[*?\\\{\[]*}
		s=${s%/*}
		P="-regextype posix-extended -iregex \"*$s/$p$n*\""
	elif [[ $a =~ \* ]] ;then
		n=${n//./\\.}
		n=${n//.\*/\\.\\S[^/]*}
		n=${n//\?/[^/.]}
		n=${n//\*/[^/]*}
		if [[ $p =~ \* ]] ;then # if any wildcard in dir. path
			s=${p%%[*?]*}
			s=${s%/*}
			s=${s:-/}
			p=${p//\*\*/~\{~}
			p=${p//\*/[^/]+}
			p=${p//~\{~/.*}
		else
			s=$p
		fi
		P="-regextype posix-extended -iregex ^$p$n\$"
	elif [ -d $a ] ;then
		s=$a; P="-iname *"
	else
		s=$p; P="-ipath $a"
	fi
else # Relative Dir. Path
	[ "${p:0:2}" = ./ ]; re=$? # defaults to recursive if no prefix ./
	p=${p#./}
	s=~+
	if [[ $p =~ / ]] ;then # if has some dir. depth to current dir.
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
			if((re)) ;then
				P="-regextype posix-extended -iregex ^$s/.*$p$n\$"
			else
				P="-regextype posix-extended -iregex ^$s/$p$n\$"
			fi
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
	else			# if one depth dir./filename relative to current dir
		if [ $E ] ;then P="-regextype posix-extended -iregex \"*$s/$p$n*\" $opt \( $D $O $F"
		elif [ -z $n ] ;then : # if no n, nop
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
fi
((l+ll)) &&L=${L-"-exec find \{\} $lx \! -ipath \{\} -iname * $opt $D $O $F \;"}
A="find $po $s $x $P $opt \( $D $L $O $F $O $K $O $R"
((l)) ||unset L

if((d+I));then
	export -f di;eval "$A \) -exec bash -c 'di $I $d \$0' {} \; "
else
	set -o pipefail;
	(eval "$A \)" 2>&1>&3 | sed -E $'s/:(.+):(.+)/:\e[1;36m\\1:\e[1;31m\\2\e[m/'>&2 ) 3>&1
fi
}
set +f;unset IFS
}
